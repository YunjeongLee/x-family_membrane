function dydt = ODE_lig_rec(t, y, params_struct)
%% Assign params
konVAR1 = params_struct.konVAR1;
koffVAR1 = params_struct.koffVAR1;
konVAR2 = params_struct.konVAR2;
koffVAR2 = params_struct.koffVAR2;
konVAN1 = params_struct.konVAN1;
koffVAN1 = params_struct.koffVAN1;
kcVAN1_R2 = params_struct.kcVAN1_R2;
koffVAN1_R2 = params_struct.koffVAN1_R2;
kcVAR2_N1 = params_struct.kcVAR2_N1;
koffVAR2_N1 = params_struct.koffVAR2_N1;
konVBR1 = params_struct.konVBR1;
koffVBR1 = params_struct.koffVBR1;
konVBN1 = params_struct.konVBN1;
koffVBN1 = params_struct.koffVBN1;
konPlR1 = params_struct.konPlR1;
koffPlR1 = params_struct.koffPlR1;
konPlN1 = params_struct.konPlN1;
koffPlN1 = params_struct.koffPlN1;
konVAPDRa = params_struct.konVAPDRa;
koffVAPDRa = params_struct.koffVAPDRa;
konVAPDRb = params_struct.konVAPDRb;
koffVAPDRb = params_struct.koffVAPDRb;
konPDAAR2 = params_struct.konPDAAR2;
koffPDAAR2 = params_struct.koffPDAAR2;
konPDAAPDRa = params_struct.konPDAAPDRa;
koffPDAAPDRa = params_struct.koffPDAAPDRa;
konPDABR2 = params_struct.konPDABR2;
koffPDABR2 = params_struct.koffPDABR2;
konPDABPDRa = params_struct.konPDABPDRa;
koffPDABPDRa = params_struct.koffPDABPDRa;
konPDABPDRb = params_struct.konPDABPDRb;
koffPDABPDRb = params_struct.koffPDABPDRb;
konPDBBR2 = params_struct.konPDBBR2;
koffPDBBR2 = params_struct.koffPDBBR2;
konPDBBPDRa = params_struct.konPDBBPDRa;
koffPDBBPDRa = params_struct.koffPDBBPDRa;
konPDBBPDRb = params_struct.konPDBBPDRb;
koffPDBBPDRb = params_struct.koffPDBBPDRb;
konR1N1 = params_struct.konR1N1;
koffR1N1 = params_struct.koffR1N1;

%% Distribute y
VA = y(1);
VB = y(2);
Pl = y(3);
PDAA = y(4);
PDAB = y(5);
PDBB = y(6);
R1 = y(7);
R2 = y(8);
N1 = y(9);
PDRa = y(10);
PDRb = y(11);
VA_R1 = y(12);
VA_R2 = y(13);
VA_N1 = y(14);
VA_R2_N1 = y(15);
VA_PDRa = y(16);
VA_PDRb = y(17);
VB_R1 = y(18);
VB_N1 = y(19);
Pl_R1 = y(20);
Pl_N1 = y(21);
PDAA_R2 = y(22);
PDAA_PDRa = y(23);
PDAB_R2 = y(24);
PDAB_PDRa = y(25);
PDAB_PDRb = y(26);
PDBB_R2 = y(27);
PDBB_PDRa = y(28);
PDBB_PDRb = y(29);
R1_N1 = y(30);

%% Initialize the dydt
dVA = 0;
dVB = 0;
dPl = 0;
dPDAA = 0;
dPDAB = 0;
dPDBB = 0;
dR1 = 0;
dR2 = 0;
dN1 = 0;
dPDRa = 0;
dPDRb = 0;
dVA_R1 = 0;
dVA_R2 = 0;
dVA_N1 = 0;
dVA_R2_N1 = 0;
dVA_PDRa = 0;
dVA_PDRb = 0;
dVB_R1 = 0;
dVB_N1 = 0;
dPl_R1 = 0;
dPl_N1 = 0;
dPDAA_R2 = 0;
dPDAA_PDRa = 0;
dPDAB_R2 = 0;
dPDAB_PDRa = 0;
dPDAB_PDRb = 0;
dPDBB_R2 = 0;
dPDBB_PDRa = 0;
dPDBB_PDRb = 0;
dR1_N1 = 0;

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
dPDBB_PDRa = dPDBB_PDRa + konPDBBPDRa * PDBB * PDRa - koffPDBBPDRa * PDBB_PDRa;

%% PDBB + PDRb <-> PDBB_PDRb
dPDBB      = dPDBB      - konPDBBPDRb * PDBB * PDRb + koffPDBBPDRb * PDBB_PDRb;
dPDRb      = dPDRb      - konPDBBPDRb * PDBB * PDRb + koffPDBBPDRb * PDBB_PDRb;
dPDBB_PDRb = dPDBB_PDRb + konPDBBPDRb * PDBB * PDRb - koffPDBBPDRb * PDBB_PDRb;

%% R1 + N1 <-> R1_N1
dR1    = dR1    - konR1N1 * R1 * N1 + koffR1N1 * R1_N1;
dN1    = dN1    - konR1N1 * R1 * N1 + koffR1N1 * R1_N1;
dR1_N1 = dR1_N1 + konR1N1 * R1 * N1 - koffR1N1 * R1_N1;

%% Gather dydt
dydt = [dVA; dVB; dPl; dPDAA; dPDAB; dPDBB; dR1; dR2; dN1; dPDRa; dPDRb; ...
        dVA_R1; dVA_R2; dVA_N1; dVA_R2_N1; dVA_PDRa; dVA_PDRb; ...
        dVB_R1; dVB_N1; dPl_R1; dPl_N1; ...
        dPDAA_R2; dPDAA_PDRa; ...
        dPDAB_R2; dPDAB_PDRa; dPDAB_PDRb; ...
        dPDBB_R2; dPDBB_PDRa; dPDBB_PDRb; ...
        dR1_N1];