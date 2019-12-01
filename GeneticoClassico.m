%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%   Algoritmo Genetico Classico aplicado a Imaginacao do Movimento BCI   %
%                                                                        %
%   TCC 2019															 %
%   Maria B Kersanach, RA 156571                                         %
%   Romis R F Attux DCA FEEC UNICAMP                                     %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clear all;

close all;

sujeito = '156571';

[H, vrotulos] = trataSinais(sujeito);

%% probabilidades de ocorrerem os fenomenos geneticos
probCross = 0.9;
probTroca = 0.5;
probMut = 0.2;

%% parametros da interface
numAtrib = 16; % 20 atributos a serem selecionados = 16 eletrodos + 4 bandas
tamPop = 20; % tamanho da populacao

% garantir que tamPop Ã© par
if mod(tamPop,2) > 0
    tamPop = tamPop+1;
end

% Gera populacao inicial de pais (vetores binarios aleatorios)
populacao = randi([0 1], tamPop, numAtrib); % matriz populacao com atributos 0s e 1s 

% NÃºmero de IteraÃ§Ãµes
Nit = 150;
global ErroIt;

%% %%%	INICIO DO CICLO

for it = 1:Nit
    it
	% Calculo do valor da funcao fitness para cada individuo da populacao
	fitness = fit(H, vrotulos, populacao);	% guarda os valores em um vetor fitness


	%% Inicio CROSSOVER

	numCross = tamPop / 2; 	% define o numero de vezes que ocorrera tentativa de crossover
    filhos = [];            % matriz que guarda os filhos gerados pelo crossover
    
	for cr = 1:numCross

		% Escolha do par -> pais = [x y]
		for kk = 1:2
			% Escolhe dois candidatos (numeros aleatorios - indice na populacao)
			cand1 = randi(tamPop);
			cand2 = randi(tamPop);

			% Escolhe o primeiro pai por TORNEIO BINARIO
			if fitness(cand1) > fitness(cand2) 
				par(kk) = cand1;

            else par(kk) = cand2;
			end
        end
        
        f = populacao(par, :); % cria dois filhos (vetores) iguais aos pais
       
		temCross = rand; 	% probabilidade de o par ser submetido ao crossover

		if temCross <= probCross        % vai ser submetido ao CROSSOVER uniforme
			troca = rand(1, numAtrib); 	% vetor aleatorio com probabilidades de troca para cada atributo
			
			for kk = 1:numAtrib
				if troca(kk) <= probTroca 	% ocorre TROCA de material genetico entre os individuos!!
					aux = f(1, kk);
					f(1, kk) = f(2, kk);
					f(2, kk) = aux;
                    disp('teve troca');
				end
            end
        end
        
        filhos = [filhos; f]; % concatena os filhos anteriores com os recem gerados
	end

	% Fim CROSSOVER


	%% Inicio MUTACAO

	mascMut = rand(tamPop, numAtrib); 	% cria matriz aleatoria com probabilidades de cada atributo sofrer mutacao

	% percorre a matriz procurando posicoes onde ocorrera mutacao
	for k = 1:tamPop
		for kk = 1:numAtrib
			if mascMut(k, kk) <= probMut 	% ocorre mutacao
				filhos(k, kk) = 1 - filhos(k, kk); % realiza a MUTACAO
                disp('teve mutacao');
			end
		end
    end
    
	% Fim MUTACAO

	%% Concatena verticalmente a matriz original de pais com a de filhos submetida a crossover e mutacao
	pop = vertcat(populacao, filhos); 

	% Calculo do valor da funcao fitness para cada individuo da populacao total (pais + filhos)
	fitness_pop = fit(H, vrotulos, pop);	% guarda os valores em um vetor fitness
    
	[fitness_pop,indices] = sortrows(fitness_pop'); 	% ordena os fitness
    pop = pop(indices,:); % reordena a matriz populacao em ordem crescente de fitness

	fitness = fitness_pop(end-tamPop+1:end); % guarda os ultimos fitness (maiores)
    populacao = pop(end-tamPop+1:end,:); % seleciona os ultimos individuos da populacao (maiores fitness)


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Parametros para criterio de parada - ciclo geral
    fitmaior(it) = fitness(end); % guarda o maior fitness da iteracao atual (GLOBAL)
    fitmedio(it) = mean(fitness); % calcula o fitness medio da iteracao atual (GLOBAL)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(1);
    plot(fitmaior, 'b');
    hold on;
    plot(fitmedio, 'r');
    hold on;
    
    figure(2);
    plot(ErroIt);
    hold on;
    
end

   % fim do CICLO
