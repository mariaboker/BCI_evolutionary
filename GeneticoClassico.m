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

global EQM_pop;

sujeito = '156571_20161107';

[H, vrotulos] = trataSinais(sujeito);

%% probabilidades de ocorrerem os fenomenos geneticos
probCross = 0.9;
probTroca = 0.5;
probMut = 0.2;

%% parametros da interface
numAtrib = 16; 
tamPop = 40; % tamanho da populacao

% garantir que tamPop Ã© par
if mod(tamPop,2) > 0
    tamPop = tamPop+1;
end

% Gera populacao inicial de pais (vetores binarios aleatorios)
populacao = randi([0 1], tamPop, numAtrib); % matriz populacao com atributos 0s e 1s 

% NÃºmero de IteraÃ§Ãµes
Nit = 50;

%% %%%	INICIO DO CICLO

for it = 1:Nit
	% Calculo do valor da funcao fitness para cada individuo da populacao
	[fitness, Erro] = fit(H, vrotulos, populacao);	% guarda os valores em um vetor fitness


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
			end
		end
    end
    
	% Fim MUTACAO

	%% Concatena verticalmente a matriz original de pais com a de filhos submetida a crossover e mutacao
	pop = vertcat(populacao, filhos); 

	% Calculo do valor da funcao fitness para cada individuo da populacao total (pais + filhos)
	[fitness_pop, Erro] = fit(H, vrotulos, pop);	% guarda os valores em um vetor fitness
    
    ErroGeracoes(it) = mean(Erro);
    ErrominGer(it) = min(Erro);
    EQMminGeracoes(it) = min(EQM_pop);
    
	[fitness_pop,indices] = sortrows(fitness_pop'); 	% ordena os fitness
    pop = pop(indices,:); % reordena a matriz populacao em ordem crescente de fitness

	fitness = fitness_pop(end-tamPop+1:end); % guarda os ultimos fitness (maiores)
    populacao = pop(end-tamPop+1:end,:); % seleciona os ultimos individuos da populacao (maiores fitness)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Parametros para criterio de parada - ciclo geral
    fitmaior(it) = fitness(end); % guarda o maior fitness da iteracao atual (GLOBAL)
    fitmedio(it) = mean(fitness); % calcula o fitness medio da iteracao atual (GLOBAL)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end

EQMmenor = EQMminGeracoes(Nit)
figure(1);
plot(fitmaior, 'b');
hold on;
plot(fitmedio, 'r');
hold on;


plot(ErroGeracoes, 'k');
hold on;
plot(ErrominGer, 'g');
hold on;
