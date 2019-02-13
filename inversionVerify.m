%% Verify
%sessionObject.loadProject('Laudau_207_2L_new.mat');
mudRes=0.1;
bh=8.5;
Laudau = sessionObject.rCSF.a_Wells(1);
RS = Laudau.a_logSets.getLogByName('RS');
RD = Laudau.a_logSets.getLogByName('RD');
csf = sessionObject.rCSF;
well_verify = csf.addNewWell('HALS_3L');
%fl = [Laudau.rEM.mdPetroBB(13)-0.3 Laudau.rEM.mdPetroBB(end)+0.3];
fl = [Laudau.rEM.mdPetroBB(bed_idx)-20*0.1524 Laudau.rEM.mdPetroBB(bed_idx+layer+1)+20*0.1524];
well_verify.FocusLimits = fl;
well_verify.modelingLimits = fl;
em_verify = well_verify.rEM;
em_verify.setProperty('propName', 'Resistivity', 'value', mudRes, 'zoneIdx', 1);
em_verify.setProperty('propName', 'Radius', 'value', bh/39.3701, 'zoneIdx', 1);
em_verify.deleteBB('mdSegment', fl);
for i = 135:138
    em_verify.addBB('md', Laudau.rEM.mdPetroBB(i));
end
resSim_verify = well_verify.Simulators.Resistivity;
reSim_verify.SamplingInterval = 0.1524;
resSim_verify.Tool = resSim_verify.allowedTools.HALS;
%resSim_verify.Variant = resSim_verify.allowedVariants.vrnt_2_DSchlumberger;
% idx_RD_top_1=find(RD.depthData>=fl(1) & RD.depthData<=Laudau.rEM.mdPetroBB(1));
% idx_RD_top_2=find(RD.depthData>=Laudau.rEM.mdPetroBB(1) & RD.depthData<=Laudau.rEM.mdPetroBB(2));
% idx_RD_bott_1=find(RD.depthData>=Laudau.rEM.mdPetroBB(end-1) & RD.depthData<=Laudau.rEM.mdPetroBB(end));
% idx_RD_bott_2=find(RD.depthData>=Laudau.rEM.mdPetroBB(end) & RD.depthData<=fl(2));
% resTop = [mean(RD.rawData(idx_RD_top_1)); mean(RD.rawData(idx_RD_top_2))];
% resBott = [mean(RD.rawData(idx_RD_bott_1)); mean(RD.rawData(idx_RD_bott_2))];
% Rem = csvread('Rem_Laudau207_2L_new.csv');
% em_verify.setProperty('propName', 'Resistivity', ...
%                 'value', [resTop; Rem(:,2); resBott], ...
%                 'zoneIdx', 'formation');
em_verify.setProperty('propName', 'Resistivity', ...
                'value', [3.6270; 3.253561;3.7570138;3.4288905; 3.7240], ...
                'zoneIdx', 'formation');
resSim_verify.run