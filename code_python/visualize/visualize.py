import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

def visualize_dynamics(results, result_foldername):
    ## Calculate concentrations of free and bound species
    free_vs_bound_lig, free_vs_bound_rec = calculate_free_vs_bound_species(results)
    
    ## Define colors
    color_lig = {"VEGF-A":'#ff595e', "VEGF-B": '#ff924c', "PlGF":'#ffca3a', \
        "PDGF-AA":'#8ac926', "PDGF-AB":'#1982c4', "PDGF-BB":'#6a4c93'}
    color_rec = {"VEGFR1":'#8ecae6', "VEGFR2":'#219ebc', "NRP1":'#023047', \
        r"PDGFR$\alpha$":'#ffb703', r"PDGFR$\beta$":'#fb8500'}

    # Plot ligand dynamics
    change_unit = 1e12
    ylabels = 'pM'
    ylimit = [0, 1200]
    filename = result_foldername + "/dynamics_free_vs_bound_lig"
    plot_free_vs_bound(free_vs_bound_lig, change_unit, color_lig, ylabels, ylimit, filename)
    
    # Plot receptor dynamics
    avogadro = 6.02214e23
    EC_vol = 1e-12 # liter
    change_unit = avogadro * EC_vol
    ylabels = 'Receptors/cell'
    ylimit = [0, 4.5e4]
    filename = result_foldername + "/dynamics_free_vs_bound_rec"
    plot_free_vs_bound(free_vs_bound_rec, change_unit, color_rec, ylabels, ylimit, filename)
    
def visualize_lig_prop(results, result_foldername):
    ## Define color
    color = ['#345995', '#eac435']
    
    ## Calculate concentrations of free and bound ligands
    free_vs_bound_lig, _ = calculate_free_vs_bound_species(results)
        
    ## Get percetage dataframe
    data = get_percentage(free_vs_bound_lig, "free_vs_bound")
    
    ## Plot bar graph
    ax = data.plot(kind='bar', stacked=True, color = color, figsize=(6, 3))
    add_text(ax)
    plt.xticks(rotation=0)
    plt.xlabel('Ligand')
    plt.ylabel('Percentage (%)')
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1))
    plt.tight_layout()
    plt.savefig(result_foldername + "/Ligand_free_VS_bound.pdf", format="pdf")
    
def visualize_rec_prop(results, result_foldername):
    ## Define colors
    color_lig = {"VEGF-A":'#ff595e', "VEGF-B": '#ff924c', "PlGF":'#ffca3a', \
        "PDGF-AA":'#8ac926', "PDGF-AB":'#1982c4', "PDGF-BB":'#6a4c93'}
    color_fb = ['#345995', '#eac435']
    
    ## Calculate concentrations of free and bound receptors
    _, free_vs_bound_rec = calculate_free_vs_bound_species(results)
    
    ## Get percetage dataframe
    data = get_percentage(free_vs_bound_rec, "free_vs_bound")
    
    ## Plot free vs. bound bar graph
    ax = data.plot(kind='bar', stacked=True, color = color_fb, figsize=(6, 3))
    add_text(ax)
    plt.xticks(rotation=0)
    plt.xlabel('Ligand')
    plt.ylabel('Percentage (%)')
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1))
    plt.tight_layout()
    plt.savefig(result_foldername + "/Receptor_free_VS_bound.pdf", format="pdf")
    
    ## Get ligand distribution dataframe
    data = get_percentage(results, "ligand_dist")
    
    ## Plot free vs. bound bar graph
    ax = data.plot(kind='bar', stacked=True, color = color_lig, figsize=(6, 3))
    add_text(ax)
    plt.xticks(rotation=0)
    plt.xlabel('Receptor')
    plt.ylabel('Percentage (%)')
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1))
    plt.tight_layout()
    plt.savefig(result_foldername + "/Receptor_ligand_dist.pdf", format="pdf")

def plot_free_vs_bound(df, change_unit, color_list, ylabels, ylimit, filename):
    # Figure size
    plt.figure(figsize=(6, 3))
    for column in df.columns:
        species = column.replace(" (Free)", "").replace(" (Bound)", "")
        if column != 'time':  # Specify that 'time' is the independent variable
            if "Free" in column:
                defined_linestyle = "solid"
            elif "Bound" in column:
                defined_linestyle = "dotted"
            else:
                print("Error: The species name does not include Free or Bound substrings.\n")
            sns.lineplot(x=df['time']/3600, y=df[column]*change_unit, label=column, \
                color = color_list.get(species), linestyle=defined_linestyle)
    sns.set_style("whitegrid", {'grid.linestyle': '--'})
    plt.xlabel('Time (hour)')
    plt.ylabel(ylabels)
    plt.ylim(ylimit)
    plt.legend(loc='upper left', bbox_to_anchor=(1, 1))
    plt.tight_layout()
    
    # Save as figure
    plt.savefig(filename + ".pdf", format="pdf")
    
def get_percentage(results, which):
    ## which: either "free_vs_bound" or "ligand_dist"
    match which:
        case "free_vs_bound":
            ## Get only final values
            df = pd.DataFrame(results.iloc[-1, 1:])
            df.columns = ['Value']

            ## Calculate the percentage
            data = pd.DataFrame()
            data['Free'] = df['Value'][::2].values / (df['Value'][::2].values + df['Value'][1::2].values) * 100
            data['Bound'] = df['Value'][1::2].values / (df['Value'][::2].values + df['Value'][1::2].values) * 100

            ## Get species names and add them to the dataframe
            species_list = results.columns[1:]
            species_list = list(dict.fromkeys([label.split(' ')[0] for label in species_list]))
            data.index = species_list
        case "ligand_dist":
            ## Get only final values
            df = pd.DataFrame(results.iloc[-1, 1:])
            
            ## Get distribution of each receptor
            data = pd.DataFrame()
            data['VEGF-A'] = [df.loc['[VA_R1]'].item(), \
                df.loc['[VA_R2]'].item() + df.loc['[VA_R2_N1]'].item(), \
                df.loc['[VA_N1]'].item() + df.loc['[VA_R2_N1]'].item(), \
                df.loc['[VA_PDRa]'].item(), df.loc['[VA_PDRb]'].item()]
            data['VEGF-B'] = [df.loc['[VB_R1]'].item(), 0, df.loc['[VB_N1]'].item(), 0, 0]
            data['PlGF'] = [df.loc['[Pl_R1]'].item(), 0, df.loc['[Pl_N1]'].item(), 0, 0]
            data['PDGF-AA'] = [0, df.loc['[PDAA_R2]'].item(), 0, df.loc['[PDAA_PDRa]'].item(), 0]
            data['PDGF-AB'] = [0, df.loc['[PDAB_R2]'].item(), 0, df.loc['[PDAB_PDRa]'].item(), df.loc['[PDAB_PDRb]'].item()]
            data['PDGF-BB'] = [0, df.loc['[PDBB_R2]'].item(), 0, df.loc['[PDBB_PDRa]'].item(), df.loc['[PDBB_PDRb]'].item()]
            
            ## Normalize data by row Sums
            data = data.div(data.sum(axis=1), axis=0) * 100
            
            ## Change index of data
            data.index = ['VEGFR1', 'VEGFR2', 'NRP1', r"PDGFR$\alpha$", r"PDGFR$\beta$"]
    
    return data
    
def calculate_free_vs_bound_species(results):
    ## Get species names
    colNames = list(results.columns)
    
    ## List of ligands and receptors
    lig = ['VA', 'VB', 'Pl', 'PDAA', 'PDAB', 'PDBB']
    lig_names = {"VA":'VEGF-A', "VB":'VEGF-B', "Pl":'PlGF', "PDAA":'PDGF-AA', "PDAB":'PDGF-AB', "PDBB":'PDGF-BB'}
    rec = ['R1', 'R2', 'N1', 'PDRa', 'PDRb']
    rec_names = {"R1":'VEGFR1', "R2":'VEGFR2', "N1":'NRP1', "PDRa":r"PDGFR$\alpha$", "PDRb":r"PDGFR$\beta$"}
    
    ## Initialize dataframe
    free_vs_bound_lig = pd.DataFrame(results['time'])
    
    ## Find free and bound ligands and store them in the dataframe
    for ligand in lig:
        # Find index of free and bound ligands
        idx_free = colNames.index('[' + ligand + ']')
        idx_bound = [i for i, s in enumerate(colNames) if ligand+'_' in s]
        # Extract free ligand column
        new_free = results[[colNames[idx_free]]].reset_index(drop=True)
        # Change column name
        new_free.columns = [lig_names.get(ligand) + ' (Free)']
        # Extract bound ligand columns and sum them
        new_bound = pd.DataFrame(results[[colNames[i] for i in idx_bound]].sum(axis=1).reset_index(drop=True))
        # Change column name
        new_bound.columns = [lig_names.get(ligand) + ' (Bound)']
        free_vs_bound_lig = pd.concat([free_vs_bound_lig, new_free, new_bound], axis=1)
        
    ## Initialize dataframe
    free_vs_bound_rec = pd.DataFrame(results['time'])

    ## Find free and bound receptors and store them in the dataframe
    for receptor in rec:
        # Find index of free and bound ligands
        idx_free = [colNames.index('[' + receptor + ']')]
        if receptor == 'R1' or receptor == 'N1':
            idx_free += [colNames.index('[R1_N1]')]
        idx_bound = [i for i, element in enumerate(colNames) if '_'+receptor in element and element != '[R1_N1]']
        # Extract free ligand column
        new_free = pd.DataFrame(results[[colNames[i] for i in idx_free]].sum(axis=1).reset_index(drop=True))
        # Change column name
        new_free.columns = [rec_names.get(receptor) + ' (Free)']
        # Extract bound ligand columns and sum them
        new_bound = pd.DataFrame(results[[colNames[i] for i in idx_bound]].sum(axis=1).reset_index(drop=True))
        # Change column name
        new_bound.columns = [rec_names.get(receptor) + ' (Bound)']
        free_vs_bound_rec = pd.concat([free_vs_bound_rec, new_free, new_bound], axis=1)
        
    return free_vs_bound_lig, free_vs_bound_rec

def add_text(plot_axes):
    for p in plot_axes.patches:
        width, height = p.get_width(), p.get_height()
        x, y = p.get_xy() 
        plot_axes.text(x+width/2,
                       y+height/2, 
                       '{:.0f}'.format(height),
                       horizontalalignment='center',
                       verticalalignment='center',
                       color='black',
                       fontsize=8)