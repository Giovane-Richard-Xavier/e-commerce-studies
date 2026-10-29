
FROM node:20-slim

WORKDIR /home/node/app

# Dependências necessárias para o Prisma
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl bash \
    && rm -rf /var/lib/apt/lists/*

# Copia os arquivos de dependências
COPY package*.json ./

# Copia o schema antes do npm install,
# pois o postinstall executa prisma generate
COPY prisma ./prisma

# Instala as dependências
RUN npm install

# Copia o restante do projeto
COPY . .

# Gera o Prisma Client
RUN npx prisma generate

# Compila o NestJS
RUN npm run build

# Verifica se a compilação foi gerada
RUN echo "======================================" \
    && echo "Checking dist directory..." \
    && echo "======================================" \
    && ls -la dist

# Permissão de execução do entrypoint
RUN chmod +x .docker/entrypoint.sh

# Porta da aplicação
EXPOSE 3001

# Inicia a aplicação
ENTRYPOINT ["/home/node/app/.docker/entrypoint.sh"]
