% Copyright (C) 2020 Robert Jonsson <robjonss@kth.se>
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%addpath('/Users/robertkth/Documents/GitHub/GCMMA-MMA-code-1.5') %path to GCMMA MATLAB functions
%addpath('/Users/robertkth/Documents/GitHub/beamEB') %path to constraint solver [you could add a different solver]
%addpath('/Users/robertkth/Documents/GitHub/Timoshenko') %path to constraint solver [you could add a different solver]
%addpath('/Users/robertkth/Documents/GitHub/DriveCycles') %path to drive cycles, for use phase.



classdef EoLmodel
    %EOLMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
%     properties
%         Property1
%     end
    
    methods(Static)
        
        function EoL_energy = LCEcredit(model,LCE)
            treatment = model.treatment;
            
            switch treatment
                case 'split credits' 
                    credit = model.credit;
                    EoL_energy = ones(1,numel(LCE));
                    EoL_energy(1) = eval(extractBefore(credit,3))/100;
                    EoL_energy(end) = eval(extractAfter(credit,3))/100; 
                    EoL_energy = LCE.*EoL_energy;
                    
                case 'correction factor'
                    degradation = model.degradation;
                    CF = (100-eval(extractBefore(degradation,'%')))/100; %Convert char to double
                    CF_vec = ones(1,numel(LCE));
                    CF_vec(end) = CF;
                    EoL_energy = LCE.*CF_vec;
                    
                case 'alternative material'
                    
                    
                    
                case 'allocation'
                    allowed_degradation = eval(extractBefore(model.alloweddegradation,'%')); %Convert char to double
                    degradation = (100-eval(extractBefore(model.degradation,'%')))/100; %Convert char to double
                    
                    %This while-loop determines how many times the material
                    %can be recycled before reaching its ultimate
                    %termination.
                    k = 0;
                    material_quality = 100;
                    while material_quality >= 100-allowed_degradation 
                        material_quality = material_quality*degradation;
                        if material_quality == 100
                            warning('Infinite reusage, zero material degradation')
                            break 
                        end
                        k = k + 1; 
                    end
                    LCE(1) = LCE(1)/k;
                    EoL_energy = LCE;
                    
                case 'equal share'
                    %Extracting the second material which is resued.
                    %material2 = model.material2{1};
                    model.EProd2=materialsData(ismember([materialsData.info],model.material2)).productionEnergy{1};
                    model.EDisp2=materialsData(ismember([materialsData.info],model.material2)).disposalEnergy{1};
                    model.EEoL2=materialsData(ismember([materialsData.info],model.material2)).eolEnergy{1};
                    model.CO2Prod2=materialsData(ismember([materialsData.info],model.material2)).productionCO2{1};
                    model.CO2Disp2=materialsData(ismember([materialsData.info],model.material2)).disposalCO2{1};
                    model.CO2EoL2=materialsData(ismember([materialsData.info],model.material2)).eolCO2{1};
                    model.Cost2=materialsData(ismember([materialsData.info],model.material2)).price{1};
                    
                    %Extracting the fractions for virgin/recycled material.
                    vM = eval(extractBefore(model.esDistribution,3))/100;
                    rM = 1-vM;
                    
                    eol_factor = eval(extractBefore(model.eol_factor,3))/100;
                    
                    LCE(1) = LCE(1)*vM + rM*(model.EProd2+model.EEoL2);
                    
                    LCE(4) = LCE(4)*eol_factor - LCE(1)*(1-eol_factor);
                    EoL_energy = LCE;

                case 'recycled content'
                 
            end
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        
    end
end

