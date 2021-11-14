
load('ir_jbf_d4.mat')
A=padarray(ir_jbf_d4,[1,1],0,'both');
for m=2:size(ir_jbf_d4,1)
    for n=2:size(ir_jbf_d4,2)
        temp=A(m-1:m+1,n-1:n+1);
        newmatrix(m-1,n-1)=mean2(temp);
    end
end
