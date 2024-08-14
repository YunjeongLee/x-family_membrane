function dydt = ODE_lig_rec(t, y, params_struct)
%% Assign params
assign_params(params_struct);

%% Distribute y
y_cell = num2cell(y);
y_struct = cell2struct(y_cell, params_struct.species_names);

assign_params(y_struct);

%% Initialize the dydt
dydt_names = strcat('d', params_struct.species_names);
dydt_values = num2cell(zeros(length(y), 1));

dydt_struct = cell2struct(dydt_values, dydt_names);

assign_params(dydt_struct);

%% Define the ODE system
%% VA + R1 <-> VA_R1
dVA    = dVA    - konVAR1 * VA * R1 + koffVAR1 * VA_R1;
dR1    = dR1    - konVAR1 * VA * R1 + koffVAR1 * VA_R1;
dVA_R1 = dVA_R1 + konVAR1 * VA * R1 - koffVAR1 * VA_R1;

%% VA + R2 <-> VA_R2
dVA    = dVA    - konVAR2 * VA * R2 + koffVAR2 * VA_R2;
dR2    = dR2    - konVAR2 * VA * R2 + koffVAR2 * VA_R2;
dVA_R2 = dVA_R2 + konVAR2 * VA * R2 - koffVAR2 * VA_R2;

%% VA + N1 <-> VA_N1
dVA    = dVA    - konVAN1 * VA * N1 + koffVAN1 * VA_N1;
dN1    = dN1    - konVAN1 * VA * N1 + koffVAN1 * VA_N1;
dVA_N1 = dVA_N1 + konVAN1 * VA * N1 - koffVAN1 * VA_N1;

%% VA_N1 + R2 <-> VA_R2_N1
dVA_N1    = dVA_N1    - kcVAN1_R2 * VA_N1 * R2 + koffVAN1_R2 * VA_R2_N1;
dR2       = dR2       - kcVAN1_R2 * VA_N1 * R2 + koffVAN1_R2 * VA_R2_N1;
dVA_R2_N1 = dVA_R2_N1 + kcVAN1_R2 * VA_N1 * R2 - koffVAN1_R2 * VA_R2_N1;

%% VA_R2 + N1 <-> VA_R2_N1
dVA_R2    = dVA_R2    - kcVAR2_N1 * VA_R2 * N1 + koffVAR2_N1 * VA_R2_N1;
dN1       = dN1       - kcVAR2_N1 * VA_R2 * N1 + koffVAR2_N1 * VA_R2_N1;
dVA_R2_N1 = dVA_R2_N1 + kcVAR2_N1 * VA_R2 * N1 - koffVAR2_N1 * VA_R2_N1;

%% VA + PDRa <-> VA_PDRa
dVA      = dVA      - konVAPDRa * VA * PDRa + koffVAPDRa * VA_PDRa;
dPDRa    = dPDRa    - konVAPDRa * VA * PDRa + koffVAPDRa * VA_PDRa;
dVA_PDRa = dVA_PDRa + konVAPDRa * VA * PDRa - koffVAPDRa * VA_PDRa;

%% VA + PDRb <-> VA_PDRb
dVA      = dVA      - konVAPDRb * VA * PDRb + koffVAPDRb * VA_PDRb;
dPDRb    = dPDRb    - konVAPDRb * VA * PDRb + koffVAPDRb * VA_PDRb;
dVA_PDRb = dVA_PDRb + konVAPDRb * VA * PDRb - koffVAPDRb * VA_PDRb;

%% VB + R1 <-> VB_R1
dVB    = dVB    - konVBR1 * VB * R1 + koffVBR1 * VB_R1;
dR1    = dR1    - konVBR1 * VB * R1 + koffVBR1 * VB_R1;
dVB_R1 = dVB_R1 + konVBR1 * VB * R1 - koffVBR1 * VB_R1;

%% VB + N1 <-> VB_N1
dVB    = dVB    - konVBN1 * VB * N1 + koffVBN1 * VB_N1;
dN1    = dN1    - konVBN1 * VB * N1 + koffVBN1 * VB_N1;
dVB_N1 = dVB_N1 + konVBN1 * VB * N1 - koffVBN1 * VB_N1;

%% Pl + R1 <-> Pl_R1
dPl    = dPl    - konPlR1 * Pl * R1 + koffPlR1 * Pl_R1;
dR1    = dR1    - konPlR1 * Pl * R1 + koffPlR1 * Pl_R1;
dPl_R1 = dPl_R1 + konPlR1 * Pl * R1 - koffPlR1 * Pl_R1;

%% Pl + N1 <-> Pl_N1
dPl    = dPl    - konPlN1 * Pl * N1 + koffPlN1 * Pl_N1;
dN1    = dN1    - konPlN1 * Pl * N1 + koffPlN1 * Pl_N1;
dPl_N1 = dPl_N1 + konPlN1 * Pl * N1 - koffPlN1 * Pl_N1;

%% PDAA + R2 <-> PDAA_R2
dPDAA    = dPDAA    - konPDAAR2 * PDAA * R2 + koffPDAAR2 * PDAA_R2;
dR2      = dR2      - konPDAAR2 * PDAA * R2 + koffPDAAR2 * PDAA_R2;
dPDAA_R2 = dPDAA_R2 + konPDAAR2 * PDAA * R2 - koffPDAAR2 * PDAA_R2;

%% PDAA + PDRa <-> PDAA_PDRa
dPDAA      = dPDAA      - konPDAAPDRa * PDAA * PDRa + koffPDAAPDRa * PDAA_PDRa;
dPDRa      = dPDRa      - konPDAAPDRa * PDAA * PDRa + koffPDAAPDRa * PDAA_PDRa;
dPDAA_PDRa = dPDAA_PDRa + konPDAAPDRa * PDAA * PDRa - koffPDAAPDRa * PDAA_PDRa;

%% PDAB + R2 <-> PDAB_R2
dPDAB    = dPDAB    - konPDABR2 * PDAB * R2 + koffPDABR2 * PDAB_R2;
dR2      = dR2      - konPDABR2 * PDAB * R2 + koffPDABR2 * PDAB_R2;
dPDAB_R2 = dPDAB_R2 + konPDABR2 * PDAB * R2 - koffPDABR2 * PDAB_R2;

%% PDAB + PDRa <-> PDAB_PDRa
dPDAB      = dPDAB      - konPDABPDRa * PDAB * PDRa + koffPDABPDRa * PDAB_PDRa;
dPDRa      = dPDRa      - konPDABPDRa * PDAB * PDRa + koffPDABPDRa * PDAB_PDRa;
dPDAB_PDRa = dPDAB_PDRa + konPDABPDRa * PDAB * PDRa - koffPDABPDRa * PDAB_PDRa;

%% PDAB + PDRb <-> PDAB_PDRb
dPDAB      = dPDAB      - konPDABPDRb * PDAB * PDRb + koffPDABPDRb * PDAB_PDRb;
dPDRb      = dPDRb      - konPDABPDRb * PDAB * PDRb + koffPDABPDRb * PDAB_PDRb;
dPDAB_PDRb = dPDAB_PDRb + konPDABPDRb * PDAB * PDRb - koffPDABPDRb * PDAB_PDRb;

%% PDBB + R2 <-> PDBB_R2
dPDBB    = dPDBB    - konPDBBR2 * PDBB * R2 + koffPDBBR2 * PDBB_R2;
dR2      = dR2      - konPDBBR2 * PDBB * R2 + koffPDBBR2 * PDBB_R2;
dPDBB_R2 = dPDBB_R2 + konPDBBR2 * PDBB * R2 - koffPDBBR2 * PDBB_R2;

%% PDBB + PDRa <-> PDBB_PDRa
dPDBB      = dPDBB      - konPDBBPDRa * PDBB * PDRa + koffPDBBPDRa * PDBB_PDRa;
dPDRa      = dPDRa      - konPDBBPDRa * PDBB * PDRa + koffPDBBPDRa * PDBB_PDRa;
dPDAB_PDRa = dPDAB_PDRa + konPDBBPDRa * PDBB * PDRa - koffPDBBPDRa * PDBB_PDRa;

%% PDBB + PDRb <-> PDBB_PDRb
dPDBB      = dPDBB      - konPDBBPDRb * PDBB * PDRb + koffPDBBPDRb * PDBB_PDRb;
dPDRb      = dPDRb      - konPDBBPDRb * PDBB * PDRb + koffPDBBPDRb * PDBB_PDRb;
dPDBB_PDRb = dPDBB_PDRb + konPDBBPDRb * PDBB * PDRb - koffPDBBPDRb * PDBB_PDRb;

%% R1 + N1 <-> R1_N1
dR1    = dR1 - konR1N1 * R1 * N1 + koffR1N1 * R1_N1;
dN1    = dN1 - konR1N1 * R1 * N1 + koffR1N1 * R1_N1;
dR1_N1 = dR1_N1 + konR1N1 * R1 * N1 - koffR1N1 * R1_N1;

%% Gather dydt
dydt = [dVA; dVB; dPl; dPDAA; dPDAB; dPDBB; dR1; dR2; dN1; dPDRa; dPDRb; ...
        dVA_R1; dVA_R2; dVA_N1; dVA_R2_N1; dVA_PDRa; dVA_PDRb; ...
        dVB_R1; dVB_N1; dPl_R1; dPl_N1; ...
        dPDAA_R2; dPDAA_PDRa; ...
        dPDAB_R2; dPDAB_PDRa; dPDAB_PDRb; ...
        dPDBB_R2; dPDBB_PDRa; dPDBB_PDRb; ...
        dR1_N1];