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
                    credits = ones(1,numel(LCE));
                    credits(1) = eval(extractBefore(credit,3));
                    credits(end) = eval(extractAfter(credit,3)); 
                    EoL_energy = credits;
                    
                case 'correction factor'
                    degradation = model.degradation;
                    CF = (100-eval(extractBefore(degradation,'%')))/100;
                    EoL_energy = model.EEoL*CF;
                    
            end
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        
    end
end

