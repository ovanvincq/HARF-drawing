function [Pmin,Pmax] = optimisation_P(param,T,P)

    result=zeros(1,length(P));
    parfor j=1:length(P)
        warning off;
        try
            x=optim_tension(param,T,P(j),1E-10);
            fct=@(t,y) RK_perso(param,t,y,T,P(j));
            T0=T*param.profil(0)+273-param.dT0;
            options = odeset('Reltol',1e-10,'AbsTol',1E-15);
            sol=ode45(fct,[0 param.Lfour],[x,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0],options);
            fct=@(t,y) RK_perso_293K(param,t,y,P(j));
            sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options);
            r2w=sol.y(4,end);
            R2w=sol.y(3,end);
            w=sol.y(2,end);
            r=sqrt(r2w/w);
            R=sqrt(R2w/w);
            result(j)=abs(R/r-param.Rf/param.rf)/(param.Rf/param.rf);
            if ((abs(sol.y(1,end)-param.tension)/param.tension>0.1) || (r2w<0) || (R2w<0))
                    result(j)=NaN;
            end
        catch exception
            result(j)=Inf;
        end
    end
    
    [AA,pos]=min(result);
    Pmin=P(max(pos-1,1));
    Pmax=P(min(pos+1,length(P)));
end

