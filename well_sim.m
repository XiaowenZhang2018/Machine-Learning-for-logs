%sessionObject.loadProject('Laudau_207.mat');
Laudau = sessionObject.rCSF.a_Wells(1);
RS = Laudau.a_logSets.getLogByName('RS');
RD = Laudau.a_logSets.getLogByName('RD');
layer = 3;
mudRes = 0.3;
bh = 8.5;
for bed_idx = 134%:3:length(Laudau.rEM.mdPetroBB)-layer-1
    unit_sim(RS, RD, bed_idx, mudRes, bh, sessionObject)
end
    