FROM node:20-slim

WORKDIR /home/node/app

# Dependências necessárias para o Prisma
RUN apt-get update \
    && apt-get install -y openssl bash \
    && rm -rf /var/lib/apt/lists/*

# Copia arquivos de dependências
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia o projeto
COPY . .

# Gera o Prisma Client
RUN npx prisma generate

# Compila o NestJS
RUN npm run build

# Verifica o build
RUN echo "======================================" \
    && echo "📦 Checking dist directory..." \
    && echo "======================================" \
    && ls -la dist

# Permissão do entrypoint
RUN chmod +x .docker/entrypoint.sh

# Porta da aplicação
EXPOSE 3001

# Inicia a aplicação
ENTRYPOINT ["/home/node/app/.docker/entrypoint.sh"]