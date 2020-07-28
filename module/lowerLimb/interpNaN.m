function Grf = interpNaN(Grf)

% Replace NaN by zeros
for i=1:3
    I = find(isnan(Grf(:,i))); 
    if ~isempty(I)
        ind=group(I);
        for l=1:length(ind)/2
            if ind(2*l-1)==1
                Grf(ind(2*l-1):ind(2*l),i)=Grf(ind(2*l)+1,i);
            elseif ind(2*l)==length(Grf(:,i))
                Grf(ind(2*l-1):ind(2*l),i)=Grf(ind(2*l-1)-1,i);
            else
                Grf(ind(2*l-1):ind(2*l),i)=(Grf(ind(2*l-1)-1,i)+Grf(ind(2*l)+1,i))/2;
            end
        end
    end
    clear I ind
end