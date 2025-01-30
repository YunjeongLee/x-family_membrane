import pandas as pd
import os
import tellurium as te
import seaborn as sns
from visualize import visualize as vs

## Change the working directory 
cwd = os.path.dirname(os.path.abspath(__file__))
os.chdir(cwd)

## Load parameter
df = pd.read_csv("../data/parameters.csv")

## Change unit of receptors and coupling rates
avogadro = 6.02214e23   # molecule/mol
EC_vol = 1e-12          # liter
EC_area = 1e-5          # cm2

# Find index of molecule/cell
idx = df.index[df["Unit"] == "molecule/cell"].tolist()

# Change value by chaning unit (molecule/cell -> M)
df.loc[idx, "value"] = df.loc[idx, "value"] / avogadro / EC_vol

# Find index of cm2/mol/s
idx = df.index[df["Unit"] == "cm2/mol/s"].tolist()

# Change value by chaning unit (cm2/mol/s -> 1/M/s)
df.loc[idx, "value"] = df.loc[idx, "value"] / EC_area * EC_vol

## Change type of params from dataframe to dictionary
params = df.set_index("Parameter")["value"].to_dict()

## Generate model
model_template = '''
model simple_binding
    # VA + R1 <-> VA_R1
    VA + R1 -> VA_R1; konVAR1 * VA * R1
    VA_R1 -> VA + R1; koffVAR1 * VA_R1
                 
    # VA + R2 <-> VA_R2
    VA + R2 -> VA_R2; konVAR2 * VA * R2
    VA_R2 -> VA + R2; koffVAR2 * VA_R2
    
    # VA + N1 <-> VA_N1
    VA + N1 -> VA_N1; konVAN1 * VA * N1
    VA_N1 -> VA + N1; koffVAN1 * VA_N1
    
    # VA_N1 + R2 <-> VA_R2_N1
    VA_N1 + R2 -> VA_R2_N1; kcVAN1_R2 * VA_N1 * R2
    VA_R2_N1 -> VA_N1 + R2; koffVAN1_R2 * VA_R2_N1
    
    # VA_R2 + N1 <-> VA_R2_N1
    VA_R2 + N1 -> VA_R2_N1; kcVAR2_N1 * VA_R2 * N1
    VA_R2_N1 -> VA_R2 + N1; koffVAR2_N1 * VA_R2_N1
    
    # VA + PDRa <-> VA_PDRa
    VA + PDRa -> VA_PDRa; konVAPDRa * VA * PDRa
    VA_PDRa -> VA + PDRa; koffVAPDRa * VA_PDRa
    
    # VA + PDRb <-> VA_PDRb
    VA + PDRb -> VA_PDRb; konVAPDRb * VA * PDRb
    VA_PDRb -> VA + PDRb; koffVAPDRb * VA_PDRb
    
    # VB + R1 <-> VB_R1
    VB + R1 -> VB_R1; konVBR1 * VB * R1
    VB_R1 -> VB + R1; koffVBR1 * VB_R1
    
    # VB + N1 <-> VB_N1
    VB + N1 -> VB_N1; konVBN1 * VB * N1
    VB_N1 -> VB + N1; koffVBN1 * VB_N1
    
    # Pl + R1 <-> Pl_R1
    Pl + R1 -> Pl_R1; konPlR1 * Pl * R1
    Pl_R1 -> Pl + R1; koffPlR1 * Pl_R1
    
    # Pl + N1 <-> Pl_N1
    Pl + N1 -> Pl_N1; konPlN1 * Pl * N1
    Pl_N1 -> Pl + N1; koffPlN1 * Pl_N1
    
    # PDAA + R2 <-> PDAA_R2
    PDAA + R2 -> PDAA_R2; konPDAAR2 * PDAA * R2
    PDAA_R2 -> PDAA + R2; koffPDAAR2 * PDAA_R2
    
    # PDAA + PDRa <-> PDAA_PDRa
    PDAA + PDRa -> PDAA_PDRa; konPDAAPDRa * PDAA * PDRa
    PDAA_PDRa -> PDAA + PDRa; koffPDAAPDRa * PDAA_PDRa
    
    # PDAB + R2 <-> PDAB_R2
    PDAB + R2 -> PDAB_R2; konPDABR2 * PDAB * R2
    PDAB_R2 -> PDAB + R2; koffPDABR2 * PDAB_R2
    
    # PDAB + PDRa <-> PDAB_PDRa
    PDAB + PDRa -> PDAB_PDRa; konPDABPDRa * PDAB * PDRa
    PDAB_PDRa -> PDAB + PDRa; koffPDABPDRa * PDAB_PDRa
    
    # PDAB + PDRb <-> PDAB_PDRb
    PDAB + PDRb -> PDAB_PDRb; konPDABPDRb * PDAB * PDRb
    PDAB_PDRb -> PDAB + PDRb; koffPDABPDRb * PDAB_PDRb
    
    # PDBB + R2 <-> PDBB_R2
    PDBB + R2 -> PDBB_R2; konPDBBR2 * PDBB * R2
    PDBB_R2 -> PDBB + R2; koffPDBBR2 * PDBB_R2
    
    # PDBB + PDRa <-> PDBB_PDRa
    PDBB + PDRa -> PDBB_PDRa; konPDBBPDRa * PDBB * PDRa
    PDBB_PDRa -> PDBB + PDRa; koffPDBBPDRa * PDBB_PDRa
    
    # PDBB + PDRb <-> PDBB_PDRb
    PDBB + PDRb -> PDBB_PDRb; konPDBBPDRb * PDBB * PDRb
    PDBB_PDRb -> PDBB + PDRb; koffPDBBPDRb * PDBB_PDRb
    
    # R1 + N1 <-> R1_N1
    R1 + N1 -> R1_N1; konR1N1 * R1 * N1
    R1_N1 -> R1 + N1; koffR1N1 * R1_N1
    
    # Parameters (species)
    VA = {VA}; VB = {VB}; Pl = {Pl}; PDAA = {PDAA}; PDAB = {PDAB}; PDBB = {PDBB};
    R1 = {R1}; R2 = {R2}; N1 = {N1}; PDRa = {PDRa}; PDRb = {PDRb};
    VA_R1 = {VA_R1}; VA_R2 = {VA_R2}; VA_N1 = {VA_N1}; VA_R2_N1 = {VA_R2_N1};
    VA_PDRa = {VA_PDRa}; VA_PDRb = {VA_PDRb};
    VB_R1 = {VB_R1}; VB_N1 = {VB_N1}; Pl_R1 = {Pl_R1}; Pl_N1 = {Pl_N1};
    PDAA_R2 = {PDAA_R2}; PDAA_PDRa = {PDAA_PDRa};
    PDAB_R2 = {PDAB_R2}; PDAB_PDRa = {PDAB_PDRa}; PDAB_PDRb = {PDAB_PDRb};
    PDBB_R2 = {PDBB_R2}; PDBB_PDRa = {PDBB_PDRa}; PDBB_PDRb = {PDBB_PDRb};
    R1_N1 = {R1_N1};
    
    # Parameters (kon and koff)
    # VEGF-A
    konVAR1 = {konVAR1}; koffVAR1 = {koffVAR1};
    konVAR2 = {konVAR2}; koffVAR2 = {koffVAR2};
    konVAN1 = {konVAN1}; koffVAN1 = {koffVAN1};
    kcVAN1_R2 = {kcVAN1_R2}; koffVAN1_R2 = {koffVAN1_R2};
    kcVAR2_N1 = {kcVAR2_N1}; koffVAR2_N1 = {koffVAR2_N1};
    konVAPDRa = {konVAPDRa}; koffVAPDRa = {koffVAPDRa};
    konVAPDRb = {konVAPDRb}; koffVAPDRb = {koffVAPDRb};
    # VEGF-B and PlGF
    konVBR1 = {konVBR1}; koffVBR1 = {koffVBR1};
    konVBN1 = {konVBN1}; koffVBN1 = {koffVBN1};
    konPlR1 = {konPlR1}; koffPlR1 = {koffPlR1};
    konPlN1 = {konPlN1}; koffPlN1 = {koffPlN1};
    # PDGF-AA
    konPDAAR2 = {konPDAAR2}; koffPDAAR2 = {koffPDAAR2};
    konPDAAPDRa = {konPDAAPDRa}; koffPDAAPDRa = {koffPDAAPDRa};
    # PDGF-AB
    konPDABR2 = {konPDABR2}; koffPDABR2 = {koffPDABR2};
    konPDABPDRa = {konPDABPDRa}; koffPDABPDRa = {koffPDABPDRa};
    konPDABPDRb = {konPDABPDRb}; koffPDABPDRb = {koffPDABPDRb};
    # PDGF-BB
    konPDBBR2 = {konPDBBR2}; koffPDBBR2 = {koffPDBBR2};
    konPDBBPDRa = {konPDBBPDRa}; koffPDBBPDRa = {koffPDBBPDRa};
    konPDBBPDRb = {konPDBBPDRb}; koffPDBBPDRb = {koffPDBBPDRb};
    # R1 and N1
    konR1N1 = {konR1N1}; koffR1N1 = {koffR1N1};
end
'''

# Format the model with parameter values
model = model_template.format(**params)

## Solve the ODE system
# Load the model
r = te.loada(model)

# Simulate model from 0 to 3600*24*10 seconds
result = pd.DataFrame(r.simulate(0, 3600*24*10, 36*24+1))

# Get species order and give it as the column names of dataframe
species = r.timeCourseSelections
result.columns = species

## Generate result folder
result_foldername = 'results/default'
os.makedirs(result_foldername, exist_ok=True) 

## Visualization
vs.visualize_dynamics(result, result_foldername)
vs.visualize_lig_prop(result, result_foldername)
vs.visualize_rec_prop(result, result_foldername)