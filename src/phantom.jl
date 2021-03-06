function phantom(N::Int64, n::Int64) #N:이미지 크기, n:팬텀의 타입
    #Shepp-Logan phantom n=1
    #            A     a       b        x0     y0        phi     
    #            k1    k2      k3       k4     k5        k6          
    # ---------------------------------------------------------
    sheplog = [ 1.0   0.69    0.92     0.0    0.0       0.0   ;   
               -0.98  0.6624  0.8740   0.0   -0.0184    0.0   ;
                0.01  0.2100  0.2500   0.0    0.35      0.0   ;
                0.01  0.0460  0.0460   0.0    0.1       0.0   ;
                0.01  0.0460  0.0460   0.0   -0.1       0.0   ;
                0.01  0.0460  0.0230  -0.08  -0.605     0.0   ;
                0.01  0.0230  0.0230   0.0   -0.606     0.0   ;
                0.01  0.0230  0.0460   0.06  -0.605     0.0   ;
               -0.02  0.1100  0.3100   0.22   0.0      -0.314 ;
               -0.02  0.1600  0.4100  -0.22   0.0       0.314 ]
  
    #modified-Shepp_Logan phantom n=2
    #              A    a       b        x0     y0       phi     
    #              k1   k2      k3       k4     k5       k6          
    #----------------------------------------------------------
    modishep = [  1.0  0.69    0.92     0.0    0.0      0.0   ;   
                 -0.8  0.6624  0.8740   0.0   -0.0184   0.0   ;
                  0.1  0.2100  0.2500   0.0    0.35     0.0   ;
                  0.1  0.0460  0.0460   0.0    0.1      0.0   ;
                  0.1  0.0460  0.0460   0.0   -0.1      0.0   ;
                  0.1  0.0460  0.0230  -0.08  -0.605    0.0   ;
                  0.1  0.0230  0.0230   0.0   -0.606    0.0   ;
                  0.1  0.0230  0.0460   0.06  -0.605    0.0   ;
                 -0.2  0.1100  0.3100   0.22   0.0     -0.314 ;
                 -0.2  0.1600  0.4100  -0.22   0.0      0.314 ]
  
    if n==1
      sl=sheplog
    elseif n==2
      sl=modishep
    end
  
    P = zeros(Float64, N, N)
    x = LinRange(-1,1,N)
    y = - x
  
    for k=1:10
  
      if k < 9 #회전이 없는 타원
        for i=1:N, j=1:N #i, j 헷갈리지 않게 주의
          if ( (x[j]-sl[k,4])/sl[k,2] )^2 + ( (y[i]-sl[k,5])/sl[k,3] )^2 < 1
            P[i, j]+= sl[k,1]
          end
        end
  
      else #회전이 있는 타원
        for i=1:N, j=1:N
          if ( (cos(sl[k,6])*(x[j]-sl[k,4])+sin(sl[k,6])*(y[i]-sl[k,5]))/sl[k,2] )^2+( (sin(sl[k,6])*(x[j]-sl[k,4])-cos(sl[k,6])*(y[i]-sl[k,5]))/sl[k,3] )^2< 1
            P[i, j]+= sl[k,1]
          end
        end
      end
  
    end
  
    return P
  
end