NP = 6;   %number of population
Pc = 0.7;    %probability of crossover
Pm = 0.125;     %probability of mutation
P = [0 1 1 0 0 1 0 ; 0 0 1 0 0 1 0 ; 1 0 0 0 1 0 0; 0 0 1 0 1 0 1; 1 0 1 1 0 1 0; 0 0 0 1 1 1 1];  %This should be in binary but I am getting an error if I put 0b000.1000. 
                                                               %So right now its in decimal and that's wrong. 101 will be counted as 1 hundread and 1, not as 3. 
                                                               
newP = [0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 ];                 % To hold new generation 
F = [0.4, 0.3, 0.09, 0.5, 0.03, 0.25];         %Fitness of each cromosome. 

Total_F = 0;   % To use for roulette wheel
Parent1 = 0;   %To select two parents for crossover 
Parent2 = 0;

L_c = 6;    %lenght of cromosome, I'll will need total lenght of cromosome during mutation
Ns = 0;     % Crossover site location 
Nm = 0;     % Mutation Site location
N_rm = 0;    %Randome number for mutation
Fitness = 0;    %Fitness = Fitness of ith cromosme/ summation of fitness of each cromosome, as described in example 3.5 

e = 0.001;    %(sum(F)~= 600000)

While(sum(F)~=600000)      % When F(x) = 0, sum(F) will be 6000, as given is example 3.5 
    for p = 1:NP              % NP = 6, so our roulette wheel will be used for 6 time. 
        N_rr = rand;            % Randome number 
        Total_F = 0;           %To start roulette wheel again in next iteration, it will start summation from 0 again.
        for i = 1:NP               %Our roulette wheel has 6 cromosome to select from
            Total_F = Total_F + F(i);          % Check summation one by one 
            Fitness = Total_F/sum(F);
            if Fitness >= N_rr                 % When summation become more than the randome number, it will choose that chromosome for next generation.
                Parent1 = P(i,:);
                %Pprint(Parent1);
                newP(p,:) = Parent1;            % add the selected cromosome in the list of next generation cromosome.  
                break; 
            end    
        end    
    end
    P = newP;            %To replace the old generation by a new one.
    for i = 1:6
      b = [P(i,:)];
      q = bin2dec(sprintf('%d', b));
      F(i) = 100/((q^2 - 70.*q + 1225) + e);     
    end
    Parent1 = 0;                            %As no cromosome is selected now, as we want to use this variable again 
                                            %during crossover to hold the chromosome selected for crossover.

    for i = 1:NP                                  %Again we will repeat this for 6 cromosome
        N_rc = rand;                              % Generate a randome number.
        if Pc > N_rc && Parent1 == 0              %Condition given in book.
            w1 = randperm(6,1);
            Parent1 = P(w1,:);                 %Select parent 1 and 2 for crossover randomly.
            w2 = randperm(6,1);
            Parent2 = P(w2,:);
            if Parent1 == Parent2                          % If parent1 and parent 2 are same than select parent 2 again. 
               w2 = randperm(6,1); 
               Parent2 = P(w2,:);
            end 
            
                                                   % Save the chromosome index of both parents to update their fitness score after crossover.
            
            Ns = ceil((L_c -1)*rand);                      %Select crossover site
            c1 = [Parent1(1:Ns) Parent2(Ns+1:end)];            %Offspring 1 and 2 because of crossover.
            c2 = [Parent2(1:Ns) Parent1(Ns+1:end)];
            P(w1,:) = c1;                    %put new children in the population, CP1 is the index of parents as this parent cromosome is going 
            P(w2,:) = c2;                                                    %to be replaced by offsprings
            for i = 1:6
                b = [P(i,:)];
                q = bin2dec(sprintf('%d', b));
                F(i) = 100/((q^2 - 70.*q + 1225) + e);     
            end
        end
    end

    for i = 1:NP
        N_rm = rand;
        if Pm >= N_rm
            w3 = randperm(6,1);
            MP = P(w3,:);              %A cromosome is selected randomly for mutation
                                      % to find the index for selected cromosome. We will use this index to put this cromosome back after mutation
            Nm = ceil((L_c -1)*rand);
            C = [ 0 0 0 0 0 0 0];
            C(Nm) = 1;
            
            MP = xor(MP,C);                  % This is to toggle the bit selected by MP
            P(w3,:) = MP;                             %Put the new cromosome back to the population array P.
        end
    end
    for i = 1:6
        b = [P(i,:)];
        q = bin2dec(sprintf('%d', b));
        F(i) = 100/((q^2 - 70*q + 1225) + e);     
    end
  %print(P);                  %Update the fitness value. Again same problem here, array P should be in decimal like 2.3, not like 10.11.
    %for hh = 1:6
        %Ft = 100/((P(hh,:)^2 - 70*P(hh,:) + 1225);
        %if Ft = 0
          % disp(hh);
           %disp(P(hh,:));
        %end
   % end    
end
    
        
            
        
   