set Cells;   
set Landuses; 
set ForestLanduses; 
set WetLanduses; 
set E within {Cells,Cells};   

param Existingnature {Landuses, Cells}; 
param Richness {Landuses, Cells}; 
param PhyloDiversity {Landuses, Cells}; 
param TransitionCost {Landuses, Cells}; 
param CanChange {Cells}; 
param b; 
param MinFor; 
param MinWet; 
param MinLan; 
param SpatialContiguityBonus; 

var LanduseDecision {l in Landuses, c in Cells} binary; 
var Contiguity {l in Landuses, (i,j) in E} binary;

maximize ConservationIndex:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c] * Richness[l,c] * PhyloDiversity[l,c] * CanChange[c] +
  SpatialContiguityBonus*sum{(i,j) in E, l in Landuses} (
      Contiguity[l,i,j] * CanChange[i] * CanChange[j] +
      Existingnature[l,i] * LanduseDecision[l,j] * CanChange[j]
  );

subj to PropotionalUse{c in Cells}:
  sum{l in Landuses} LanduseDecision[l,c] <= 1;

subj to MinimumCellPerLandUse{l in Landuses diff {'Ag'}}:
  sum{c in Cells} LanduseDecision[l, c] >= MinLan;

subj to NoAgriculture {c in Cells}:
  LanduseDecision['Ag', c] = 0;

subj to MinimumForest:
  sum{c in Cells, l in ForestLanduses} LanduseDecision[l,c] >= MinFor;

subj to MinimumWet:
  sum{c in Cells, l in WetLanduses} LanduseDecision[l,c] >= MinWet;

subj to Budget:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c]*TransitionCost[l,c] = b;

subj to DefineContiguity1 {l in Landuses, (i,j) in E}: 
  Contiguity[l,i,j] <= LanduseDecision[l,i];

subj to DefineContiguity2 {l in Landuses, (i,j) in E}: 
  Contiguity[l,i,j] <= LanduseDecision[l,j];

subj to DefineContiguity3 {l in Landuses, (i,j) in E}: 
  Contiguity[l,i,j] >= LanduseDecision[l,i] + LanduseDecision[l,j] - 1;
