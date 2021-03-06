type Errors
    a::Float64 # parameter distribution smoothing
    h::Float64

    odev::Vector{Float64} # σ for observation, param distributions
    pdev::Vector{Float64}

    lb::Vector{Float64} # lower/upper bounds for truncated normal param distrs.
    ub::Vector{Float64}

    Amin::Vector{Float64} # minimum values for A0 for non-measured arteries
    # bmax::Vector{Float64}

    function Errors(nparams=14)
        this = new();
        δ = 0.99; # ∃ (0, 1, typically within 0.95-0.99), lower values = less parameter dispersion
        this.a = (3*δ-1)/(2*δ);
        this.h = sqrt.(1-this.a^2);
        this.odev = [45*mmTom,20*mmTom,35*mmTom];
        # this.pdev = 1e-12*ones(nparams);
        # this.pdev = [1e9,2.3e9,1e10,4e-11,2e-11,4.8e-12,0.3,0.3,4e7,3.8e7,3.8e7];
        this.pdev = [1e9,2.3e9,1e10,4e-11,2e-11,4.8e-12,0.1,0.3,0.05,0.05,0.05,4e-7,4.3e-7,2e-7];
        this.lb = -Inf*ones(nparams);
        this.ub = Inf*ones(nparams);
        this.lb[1] = 1e9; # R1
        this.lb[2] = 2.3e9; # R2
        this.lb[3] = 1e10; # R3
        this.lb[4] = 8e-11; # C1
        this.lb[5] = 4e-11; # C2
        this.lb[6] = 1e-11; # C3
        this.lb[7] = 0.5; # Cfac
        this.lb[8] = 0.1; # Rfac
        this.lb[9] = 0.8; # Afac1
        this.lb[10] = 0.8; # Afac2
        this.lb[11] = 0.8; # Afac3
        this.lb[12] = 2e-6; # A1
        this.lb[13] = 2.15e-6; # A2
        this.lb[14] = 9.5e-7; # A3
        # this.lb[9] = 2e7; # β1
        # this.lb[10] = 2e7; # β2
        # this.lb[11] = 2e7; # β3
        this.ub[7] = 1.5;
        this.ub[8] = 3;
        this.ub[9] = 1.2;
        this.ub[10] = 1.2;
        this.ub[11] = 1.2;

        # pull in artery data from text file
        temp = LegHemodynamics.loadtexttree("arterylist_2.txt");
        this.Amin = 0.8*[temp[1,:A0_m2]];
        for i = 2:length(temp[:A0_m2])
            push!(this.Amin,0.8*temp[i,:A0_m2])
        end
        # this.bmax = 3*[temp[1,:beta_Pam]];
        # for i = 2:length(temp[:beta_Pam])
        #     push!(this.bmax,3*temp[i,:beta_Pam])
        # end
        return this
    end
end
