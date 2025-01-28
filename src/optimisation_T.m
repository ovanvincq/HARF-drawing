function [Tmin,Tmax] = optimisation_T(param,T,P)

    result=zeros(1,length(T));
    for j=1:length(T)
        try
            x=optim_tension(param,T(j),P,1E-10);
            fct=@(t,y) RK_perso(param,t,y,T(j),P);
            T0=T(j)*param.profil(0)+273-param.dT0;
            options = odeset('Reltol',1e-10,'AbsTol',1E-15);
            sol=ode45(fct,[0 param.Lfour],[x,param.w0,param.R0^2*param.w0,param.r0^2*param.w0,T0],options);
            fct=@(t,y) RK_perso_293K(param,t,y,P);
            sol=ode45(fct,[param.Lfour param.L],sol.y(:,end),options);
            R2w=sol.y(3,end);
            w=sol.y(2,end);
            R=sqrt(R2w/w);
            if ((R2w>0) && (R>1E-8))
                result(j)=abs(R-param.Rf)/param.Rf;
                if (abs(sol.y(1,end)-param.tension)/param.tension>0.1)
                    result(j)=NaN;
                end
            else
                result(j:end)=Inf;
                break;
            end
        catch exception
            result(j)=NaN;
        end
    end
    [AA,pos]=min(result);
    Tmin=T(max(pos-1,1));
    Tmax=T(min(pos+1,length(T)));
end

