#!/usr/bin/env python3
import pickle, sys, os, re, tarfile, glob
from Bio import Phylo
from Bio import SeqIO
from Bio.Phylo.BaseTree import Tree as BTree
from Bio.Phylo.BaseTree import Clade as BClade
from ete3 import NCBITaxa
ncbi = NCBITaxa()
class Nodes:
    #
    # Format of nodes.dmp from RefSeq documentation
    #
    # ---------
    #
    # This file represents taxonomy nodes. The description for each node includes
    # the following fields:
    #
    #   tax_id                  -- node id in GenBank taxonomy database
    #   parent tax_id               -- parent node id in GenBank taxonomy database
    #   rank                    -- rank of this node (superkingdom, kingdom, ...)
    #   embl code               -- locus-name prefix; not unique
    #   division id             -- see division.dmp file
    #   inherited div flag  (1 or 0)        -- 1 if node inherits division from parent
    #   genetic code id             -- see gencode.dmp file
    #   inherited GC  flag  (1 or 0)        -- 1 if node inherits genetic code from parent
    #   mitochondrial genetic code id       -- see gencode.dmp file
    #   inherited MGC flag  (1 or 0)        -- 1 if node inherits mitochondrial gencode from parent
    #   GenBank hidden flag (1 or 0)            -- 1 if name is suppressed in GenBank entry lineage
    #   hidden subtree root flag (1 or 0)       -- 1 if this subtree has no sequence data yet
    #   comments                -- free-text comments and citations
    #
    reduced_tax_levels = ['superkingdom', 'phylum',
                      'class', 'order', 'family', 'genus', 'species']
    def __init__(self):
        pass

    def __init__(self, nodes_dmp, tax_ids_to_names=None):
        # Go through every line of Nodes file to construct tree. tmp_nodes will
        # be a dictionary pointing from the taxid to its clade
        tmp_nodes = {}
        # with open( nodes_dmp_file ) as inpf:
        for line in nodes_dmp:
            (tax_id, parent_tax_id, rank, embl_code, division_id, inherited_div_flag,
             genetic_code_id, inherited_GC_flag, mitochondrial_genetic_code, inherited_MGC_flag,
             GenBank_hidden_flag, hidden_subtree_root_flag, comments) = line[::2]

    # For every entry in Nodes (every location in the tree) create clade containing the scientific name and pointer to the parent node.
    # Specify the rank of the clade and the taxonomic ID of the root.
            name = (tax_ids_to_names[int(tax_id)]
                    if tax_ids_to_names else None)

            clade = BClade(clades=[], name=name)
            clade.parent_tax_id = int(parent_tax_id)
            clade.rank = re.sub(r'\W+', '', rank).strip("_")
            clade.tax_id = int(tax_id)
            clade.initially_terminal = False
            #clade.accession = accessions[clade.tax_id] if clade.tax_id in accessions else []

    # Set clade status values to "True" for sequence data and "final" or "draft" if it appears in accessions (taxid -> name, status, accessions)
            # if clade.tax_id in accessions:
            #    clade.sequence_data = True
            #    clade.status = clade.accession['status']

            tmp_nodes[clade.tax_id] = clade

            # can add any other info in node.dmp
            
    # Build the tree using all the clades (iterate through clades using
    # tmp_nodes)
        self.tree = BTree()
        for node in tmp_nodes.values():
            # node = parent is the trick from NCBI to identify the root
            if node.tax_id == node.parent_tax_id:
                self.tree.root = node
                continue
            parent = tmp_nodes[node.parent_tax_id]
            parent.clades.append(node)

        self.taxid_n = tmp_nodes
        self.leaves_taxids = []
        self.num_nodes = 0
        # Determine initial leaves of the tree. This function is called once after loading of the tree and should NOT be called at any time later, as
        # many logical concepts of functions here are based on this assumption.
        self.determine_initial_leaves()
        self.get_leave_ids()
        self.get_nr_nodes()

    # Recursively goes through all clades in the tree. Each clade root gets
    # list of all accessions in the clade.
    def add_internal_accessions(self, clade=None):
        if not clade:
            clade = self.tree.root

        clade.all_accessions = [] + \
            ([clade.accession] if clade.accession else [])

        for child in clade.clades:
            clade.all_accessions += self.add_internal_accessions(child)
        return clade.all_accessions

    # Recursively go through tree, remove references to clades that have no
    # accession information in any of their nodes.
    def remove_subtrees_without_accessions(self, clade=None):
        if not clade:
            clade = self.tree.root
        clade.clades = [c for c in clade.clades if len(c.all_accessions)]
        for c in clade.clades:
            self.remove_subtrees_without_accessions(c)
    
    def remove_subtree_taxonomy_by_level(self, rank, names, clade=None):
        if not clade:
            clade = self.tree.root
        if clade.rank == rank:
            clade.clades = [c for c in clade.clades if clade.name in names]
        for c in clade.clades:
            self.remove_subtree_taxonomy_by_level(rank,names,c)
    
    def remove_leaves_without_proteomes(self,clade=None):
        if not clade:
            clade = self.tree.root
        clade.clades = [c for c in clade.clades if not (c.initially_terminal and not hasattr(c,'proteome'))]
        for c in clade.clades:
            self.remove_leaves_without_proteomes(c)

    # Recursively go through the tree, and at each node remove references to
    # child clades pertaining to plasmid DNA.
    def remove_plasmids(self, clade=None):
        if not clade:
            clade = self.tree.root
        clade.clades = [c for c in clade.clades if 'plasmid' not in c.name]
        for c in clade.clades:
            self.remove_plasmids(c)

    def lookup_by_rank(self):
        rankid={}
        for clade in self.tree.find_clades():
            if clade.rank:
                if clade.rank not in rankid:
                    rankid[clade.rank] = []
                rankid[clade.rank].append(clade)
        return rankid

    def determine_initial_leaves(self, clade=None):
        if not clade:
            clade = self.tree.root
        if clade.is_terminal():
            clade.initially_terminal=True
        for c in clade.clades:
            self.determine_initial_leaves(c)

    # Recursively go through the tree and remove each node that is initially terminal and whose taxid is not in the list of taxids to keep.
    # Beware that this function will only "spare" a taxon if it is initially terminal. This might be problematic in later usecases, since I'm
    # not sure whether we can garantuee that all species taxids (corresponding to proteomes) are actually ALL leave nodes in the initial tree.
    def remove_leaves(self, clade=None, taxids_to_keep=None):
        if not clade:
            clade = self.tree.root
        clade.clades = [c for c in clade.clades if (not c.initially_terminal) or (c.initially_terminal and c.tax_id in taxids_to_keep)]
        for c in clade.clades:
            self.remove_leaves(c, taxids_to_keep=taxids_to_keep)

    def get_nr_nodes(self, clade=None, num_nodes=None):
        if not clade:
            clade = self.tree.root
        if not num_nodes:
            self.num_nodes = 0
        clade.clades = [c for c in clade.clades]
        for c in clade.clades:
            self.num_nodes += 1
            self.get_nr_nodes(c, num_nodes = self.num_nodes)

    # This function removes"stub" subtrees that (can) remain after pruning unwanted leaves with the remove_leaves function.
    def remove_stub(self, clade=None):
        if not clade:
            clade = self.tree.root
        clade.clades = [c for c in clade.clades if (c.is_terminal() and c.initially_terminal) or (not c.is_terminal())]
        for c in clade.clades:
            self.remove_stub(c)

    # This function removes stubs until there are none left, returning only the tree of interest.
    def remove_subtrees(self, clade=None):
        itera = 0
        while True:
            self.get_nr_nodes()
            nds_bf = self.num_nodes
            self.remove_stub()
            self.get_nr_nodes()
            nds_af = self.num_nodes
            # Pruning is complete if no nodes were removed between last and current iteration.
            if (nds_af == nds_bf): 
                print("Subtree pruning complete")
                break
            itera += 1
            print("Removing stub subtrees. Iteration ", str(itera))


    def get_leave_ids(self, clade=None, recur=False):
        if not recur:
            self.leaves_taxids = []
        if not clade:
            clade = self.tree.root
        if clade.is_terminal():
            self.leaves_taxids.append(clade.tax_id)
        for c in clade.clades:
            self.get_leave_ids(c, recur=True)

    def go_up_to_species(self, taxid):
        if taxid in self.taxid_n and taxid > 1:
            rank = self.taxid_n[taxid].rank
            rank_index = self.reduced_tax_levels.index(rank) if rank in self.reduced_tax_levels else float('infinity')
            if rank_index > self.reduced_tax_levels.index('species'):
                father = self.taxid_n[taxid].parent_tax_id
                return self.go_up_to_species(father)
            elif rank_index == self.reduced_tax_levels.index('species'):
                return taxid
            else:
                return None

    def get_child_proteomes(self, clade):
        if clade.initially_terminal and hasattr(clade,'proteomes'):
            return copy.deepcopy(clade.proteomes)
        pp = copy.deepcopy(clade.proteomes) if hasattr(clade,'proteomes') else set()
        for c in clade.clades:
            pp.update(self.get_child_proteomes(c))
        return pp
     
    def print_full_taxonomy(self, tax_id):
        ranks2code = {'superkingdom': 'k', 'phylum': 'p', 'class': 'c',
                      'order': 'o', 'family': 'f', 'genus': 'g', 'species': 's', 'taxon': 't', 'sgb' : 't'}
        order = ('k', 'p', 'c', 'o', 'f', 'g', 's', 't')

        # path = [p for p in self.tree.root.get_path(self.taxid_n[tax_id]) if p.rank in ranks2code or (p.rank=='norank')]
        parent_tax_id = tax_id
        path = []

        while(parent_tax_id != 1):
            curr_tax = self.taxid_n[parent_tax_id]
            if curr_tax.rank in ranks2code or (curr_tax.rank=='norank'):
                path.append(curr_tax)
            parent_tax_id = curr_tax.parent_tax_id

        path.reverse()
        if path[0].name == 'cellular_organisms':
            _ = path.pop(0)
        taxa_str, taxa_ids = [], []

        hasSpecies = any([True if p.rank == 'species' else False for p in path])
        hasTaxon = any([True if (p.rank == 'norank' or p.rank == 'taxon') and p.initially_terminal else False for p in path])

        if hasSpecies and hasTaxon:
            i=-1
            isSpecies=False
            while not isSpecies:
                if not path[i].initially_terminal and path[i].rank=='norank':
                    path.remove(path[i])
                if path[i].rank=='species':
                    isSpecies=True
                    path[-1].rank = 'taxon'
                i-=1
        path = [p for p in path if p.rank != 'norank']
        taxa_str = ['{}__{}'.format(ranks2code[path[x].rank], path[x].name) for x in range(len(path)) if path[x].rank != 'norank']
        taxa_ids = ['{}__{}'.format(ranks2code[path[x].rank], path[x].tax_id) for x in range(len(path)) if path[x].rank != 'norank']

        for x in range(len(order)-1) if not hasTaxon else range(len(order)):
            if x < len(taxa_str):
                if not taxa_str[x].startswith(order[x]):
                    end_lvl = order.index(taxa_str[x][0])
                    missing_levels_str = ['{}__{}_unclassified'.format(order[i], taxa_str[x-1][3:]) for i in range(x, end_lvl)]
                    missing_levels_ids = ['{}__'.format(order[i]) for i in range(x, end_lvl)]
                    for i in range(len(missing_levels_str)):
                        taxa_str.insert(x+i, missing_levels_str[i])
                        taxa_ids.insert(x+i, missing_levels_ids[i])
        
        return ('|'.join(taxa_str), '|'.join([t.split('__')[1] for t in taxa_ids]), )
        
    def print_tree(self, out_file_name, reduced=False):

        tree = self.reduced_tree if reduced else self.tree

        #to_print = tree.find_clades({"sequence_data": True})

        ranks2code = {'superkingdom': 'k', 'phylum': 'p', 'class': 'c',
                      'order': 'o', 'family': 'f', 'genus': 'g', 'species': 's', 'taxon': 't'}

        def red_rank(rank):
            if reduced and rank in ranks2code:
                return ranks2code[rank]
            return rank

        with open(out_file_name, "w") as outf:

            def trac_print_t(clade, names=None):
                if names is None:
                    if clade.name == 'root':
                        names = ""
                    else:
                        names = red_rank(clade.rank) + '__' + clade.name
                else:
                    names += ("|" if names else "") + \
                        red_rank(clade.rank) + '__' + clade.name

                # if clade.is_terminal():
                if clade.tax_id is not None and clade.name != 'root':
                    outf.write("\t".join([clade.name,
                                          # t.accession['status'],
                                          #",".join(t.accession['gen_seqs']),
                                          str(clade.tax_id),
                                          # t.accession['code'],
                                          #",".join(t.accession['accession']),
                                          # str(t.accession['len']),
                                          names
                                          ]) + "\n")

                if not clade.is_terminal():
                    for c in clade.clades:
                        trac_print_t(c, names)
            trac_print_t(tree.root)

            """
            for t in tree.get_terminals():
                tax = "|".join([red_rank(p.rank)+'__'+p.name for p in tree.get_path( t )])
                outf.write("\t".join( [ t.name,
                                        #t.accession['status'],
                                        #",".join(t.accession['gen_seqs']),
                                        str(t.tax_id),
                                        #t.accession['code'],
                                        #",".join(t.accession['accession']),
                                        #str(t.accession['len']),
                                        tax
                                        ]    )+"\n")
            """


class Names:
    #
    # Format of names.dmp from RefSeq documentation
    #
    # ---------
    #
    # Taxonomy names file has these fields:
    #
    #   tax_id                  -- the id of node associated with this name
    #   name_txt                -- name itself
    #   unique name             -- the unique variant of this name if name not unique
    #   name class              -- (synonym, common name, ...)
    #

    def __init__(self, names_dmp):
        # Read from file names.dmp, get information in every field
        self.tax_ids_to_names = {}
        for line in names_dmp:
            tax_id, name_txt, unique, name_class = line[::2]

            # extracting scientific names only (at least for now) which are unique!
        # tax_ids_to_names relates taxid to the sole scientific name of the
        # organism
            if name_class == "scientific name":
                name = re.sub(r'\W+', '_', name_txt).strip("_")
                self.tax_ids_to_names[int(tax_id)] = name

    def get_tax_ids_to_names(self):
        return self.tax_ids_to_names

def read_taxdump(taxdump_dir, verbose=False):
    print('Reading the NCBI taxdump file from {}\n'.format(taxdump_dir))
    try:
        tarf = None

        if os.path.isfile(taxdump_dir):
            tarf = tarfile.open(taxdump_dir, "r:gz")
        else:
            print('{} does not exists. Exiting...'.format(taxdump_dir))
            sys.exit()
        for m in tarf.getmembers():
            if m.name == "names.dmp":
                names_buf = (l.decode("utf-8").strip().split('\t')
                             for l in tarf.extractfile(m).readlines())
            if m.name == "nodes.dmp":
                nodes_buf = (l.decode("utf-8").strip().split('\t')
                             for l in tarf.extractfile(m).readlines())
    except Exception as e:
        print("Error in extracting or reading {}: {}"
                    .format(taxdump_dir, e))
        sys.exit()

    print('names.dmp and nodes.dmp successfully read\n')

    return (names_buf, nodes_buf)
    
def convertMetaphlan27(mpa_inputs):
    ranks = 'superkingdom|phylum|class|order|family|genus|species'

    ranks2code = { 'k' : 'superkingdom', 'p' : 'phylum', 'c':'class',
                   'o' : 'order', 'f' : 'family', 'g' : 'genus', 's' : 'species'}
    tmp_rank = {}
    workdir = '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/hg/chocophlan/data_201804/refseq/taxdump/refseq_taxdump.tar.gz'
    names_buf, nodes_buf = read_taxdump(workdir)
    print("Starting extraction of taxonomic names... ")
    names = Names(names_buf)
    tax_tree = Nodes(nodes_buf, names.get_tax_ids_to_names())
    d_ranks = tax_tree.lookup_by_rank()
    for mpa_input in mpa_inputs:
        outl = []
        for line in open(mpa_input):
            if line.startswith('#') or 'Metaphlan2_Analysis' in line:
                line = line[1:].split()
                if line[0] == 'SampleID':
                    if re.match("[A-Za-z0-9\._]+",line[1]):
                        sampleID = line[1]
                    else:
                        exit(0)
            else:
                line = line.strip().split()
                taxapath = line[0].split('|')
                perc = line[1]
                if taxapath[-1].startswith('t__'):
                    taxapath = taxapath[:-1]
                leaf = taxapath[-1].split('__')
                leaf_rank = ranks2code[leaf[0]]
                leaf_name = leaf[1]

                if leaf_name not in tmp_rank:
                    if 'unclassified' not in leaf_name and '_noname' not in leaf_name:
                        leaf_taxid = [x.tax_id for x in d_ranks[leaf_rank] if x.name == leaf_name]
                        if leaf_taxid:
                            leaf_taxid = str(leaf_taxid[0])
                        if not leaf_taxid:
                            leaf_taxid = ncbi.get_name_translator([leaf_name.replace('_',' ')])
                            if leaf_taxid:
                                leaf_taxid = str(leaf_taxid[leaf_name.replace('_',' ')][0])
                        tmp_rank[leaf_name] = leaf_taxid
                    else:
                        continue
                else:
                    leaf_taxid = tmp_rank[leaf_name]
                    
                if not leaf_taxid:
                    leaf_taxid = ''

                TAXPATHSN = ''
                TAXPATH = ''
                for t in taxapath:
                    rank, name = t.split("__")
                    rank = ranks2code[rank]
                    if 'unclassified' not in name and '_noname' not in name:
                        if name not in tmp_rank:
                            taxid = [x.tax_id for x in d_ranks[rank] if x.name == name]
                            if taxid:
                                taxid = str(taxid[0])
                            if not taxid:
                                taxid = ncbi.get_name_translator([name.replace('_',' ')])
                                if taxid:
                                    taxid = str(taxid[name.replace('_',' ')][0])
                            tmp_rank[name] = taxid
                        else:
                            taxid = tmp_rank[name]

                        TAXPATH += str(taxid)
                        TAXPATHSN += name
                    TAXPATH += '|'
                    TAXPATHSN += '|'

                if TAXPATH.endswith('|'):
                    TAXPATH = TAXPATH[:-1]
                    TAXPATHSN = TAXPATHSN[:-1]

                outl.append('{}\t{}\t{}\t{}\t{}\n'.format(leaf_taxid, leaf_rank, TAXPATH, TAXPATHSN, perc))

        header = []
        header.extend(['@SampleID:{}\n'.format(sampleID), 
                       '@Version:0.9.1\n', 
                       '@__program__:metaphlan2\n', 
                       '@Ranks:superkingdom|phylum|class|order|family|genus|species\n', 
                       '@@TAXID\tRANK\tTAXPATH\tTAXPATHSN\tPERCENTAGE\n'])
        with open(mpa_input.replace('orig','profile'),'w') as outfn:
            outfn.writelines(header)
            outfn.writelines(outl)

def convertBracken(bracken_inputs):
    workdir = 'refseq_taxdump.tar.gz'
    names_buf, nodes_buf = read_taxdump(workdir)
    names = Names(names_buf)
    tax_tree = Nodes(nodes_buf, names.get_tax_ids_to_names())
    d_ranks = tax_tree.lookup_by_rank()
    ranks2code = { 'k' : 'superkingdom', 'p' : 'phylum', 'c':'class',
                   'o' : 'order', 'f' : 'family', 'g' : 'genus', 's' : 'species'}

    for bracken_input in bracken_inputs:
        sampleID = bracken_input.split('/')[-1].split('.')[0].split('_')[1]
        outl = []
        lines = open(bracken_input).readlines()
        for line in lines[1:]:
            line = line.strip().split('\t')

            name,taxonomy_id,taxonomy_lvl,kraken_assigned_reads,added_reads,new_est_reads,fraction_total_reads = line
            taxonomy_id = int(taxonomy_id)
            if taxonomy_id in tax_tree.taxid_n:
                TAXPATHSN, TAXPATH = list(tax_tree.print_full_taxonomy(taxonomy_id))
                TAXPATHSN = '|'.join([l[3:] if 'unclassified' not in l else '' for l in TAXPATHSN.split('|')])
            else:
                TAXPATHSN, TAXPATH = name, taxonomy_id
            outl.append('{}\t{}\t{}\t{}\t{}\n'.format(taxonomy_id, ranks2code[taxonomy_lvl.lower()], TAXPATH, TAXPATHSN, float(fraction_total_reads)*100))

        header = ['@SampleID:{}\n'.format(sampleID), '@Version:0.9.1\n', '@__program__:bracken\n', '@Ranks:superkingdom|phylum|class|order|family|genus|species\n', '@@TAXID\tRANK\tTAXPATH\tTAXPATHSN\tPERCENTAGE\n']

        with open(bracken_input.replace('.bracken','_bracken.profile'),'w') as outfn:
            outfn.writelines(header)
            outfn.writelines(outl)
