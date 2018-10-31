function [U,harmonics] = SteerableDesign(Utype,params)
%
% function [U,harmonics] = SteerableDesign(Utype,params)
%
%
% return steerable wavelet construction matrix and vector of harmonics.
%
%
% INPUTS
% ------
%
% Utype         steerable construction type (string). Available constructions
%               are 'Gradient', 'Monogenic', 'Hessian', 'CircularHarmonic',
%               'Prolate', 'ProlateUniSided', 'Slepian', 'RieszEven',
%               'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd',
%               'SimoncelliComplete', 'UserDefined'
%
% params        parameter structure for the chosen steerable construction. Set
%               this argument to the string 'help' to get a list of parameters
%               for the given Utype
%
%
% OUTPUTS
% -------
%
% U             construction matrix
%
% harmonics     vector of harmonics for the chosen design and parameters
%
%
% REFERENCE
% ---------
%
% M. Unser and N. Chenouard, "A Unifying Parametric Framework for 2D Steerable
% Wavelet Transforms", SIAM J. Imaging Sci., in press.
%
%
% AUTHOR
% ------
%
% Zs. Puspoki (zsuzsanna.puspoki@epfl.ch)
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)


helpmode = strcmp(params,'help');

U = [];
harmonics = [];

switch Utype
    case 'Gradient'
        if helpmode
            fprintf('Gradient Utype requires no parameters.\n');
            return;
        end
        [U,harmonics] = Gradient();
        
    case 'Monogenic'
        if helpmode
            fprintf('Monogenic Utype requires no parameters.\n');
            return;
        end
	[U,harmonics] = Monogenic();
        
    case 'Hessian'
        if helpmode
            fprintf('Hessian Utype requires no parameters.\n');
            return;
        end
        [U,harmonics] = Hessian();
        
    case 'CircularHarmonic'
        if helpmode
            fprintf('CircularHarmonic Utype requires parameter(s):\n');
            fprintf('.harmonics     vector of harmonics\n');
            return;
        end
	[U,harmonics] = CircularHarmonic(params.harmonics);
        
    case 'Prolate'
        if helpmode
            fprintf('Prolate Utype requires parameter(s):\n');
            fprintf('.harmonics     vector of harmonics\n');
            return;
        end
        [U,harmonics] = Prolate(params.harmonics);
        
    case 'ProlateUniSided'
        if helpmode
            fprintf('ProlateUniSided Utype requires parameter(s):\n');
            fprintf('.harmonics     vector of harmonics\n');
            return;
        end
        [U,harmonics] = ProlateUniSided(params.harmonics);  
        
    case 'Slepian'
        if helpmode
            fprintf('Slepian Utype requires parameter(s):\n');
            fprintf('.harmonics     vector of harmonics\n');
            fprintf('.B             bandwidth\n');
            return;
        end
        [U,harmonics] = Slepian(params.harmonics,params.B);         
        
    case 'RieszEven'
        if helpmode
            fprintf('RieszEven Utype requires parameter(s):\n');
            fprintf('.order         even order\n');
            return;
        end
        [U,harmonics] = RieszEven(params.order);
        
    case 'RieszOdd'
        if helpmode
            fprintf('RieszOdd Utype requires parameter(s):\n');
            fprintf('.order         odd order\n');
            return;
        end
        [U,harmonics] = RieszOdd(params.order);   
        
    case 'RieszComplete'
        if helpmode
            fprintf('RieszComplete Utype requires parameter(s):\n');
            fprintf('.order         order\n');
            return;
        end
        [U,harmonics] = RieszComplete(params.order);  
        
    case 'SimoncelliEven'
        if helpmode
            fprintf('SimoncelliEven Utype requires parameter(s):\n');
            fprintf('.order         even order\n');
            return;
        end
        [U,harmonics] = SimoncelliEven(params.order);
        
    case 'SimoncelliOdd'
        if helpmode
            fprintf('SimoncelliOdd Utype requires parameter(s):\n');
            fprintf('.order         odd order\n');
            return;
        end
        [U,harmonics] = SimoncelliOdd(params.order);
        
    case 'SimoncelliComplete'
        if helpmode
            fprintf('SimoncelliComplete Utype requires parameter(s):\n');
            fprintf('.order         order\n');
            return;
        end
        [U,harmonics] = SimoncelliComplete(params.order);
        
    case 'UserDefined'
        if helpmode
            fprintf('UserDefined Utype requires parameter(s):\n');
            fprintf('.Udef          U matrix\n');
            fprintf('.harmonics     vector of harmonics\n');
            return;
        end
        if size(params.Udef,2) ~= length(params.harmonics)
            error('incompatible Udef and harmonics');
        end
        U = params.Udef;
        harmonics = params.harmonics;

    otherwise
        fprintf('Supported Utypes:\n');
        fprintf('Gradient, Monogenic, Hessian, CircularHarmonic, Prolate, ProlateUniSided, Slepian, RieszEven, RieszOdd, RieszComplete, SimoncelliEven, SimoncelliOdd, SimoncelliComplete, UserDefined.\n');
        fprintf('Run SteerableDesign() with ''help'' as the second argument to get help on the fields of the params struct for a specific design.\n');
        error('Unsupported Utype.');
end
