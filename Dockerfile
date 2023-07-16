# Define a imagem base para Ruby 3.0.4
FROM ruby:3.0.4

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Instala o Node.js na versão 16.x
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

# Instala o Yarn
RUN npm install -g yarn

# Instala as dependências do sistema
RUN apt-get update && apt-get install -y \
    postgresql-client \
 && rm -rf /var/lib/apt/lists/*

# Copia os arquivos de código-fonte para o diretório de trabalho
COPY . .

# Instala as dependências do Ruby
RUN gem install bundler
RUN bundle install

# Instalando NPM e Yarn
RUN npm install
RUN yarn

# Instalando o mailcatcher
RUN gem install mailcatcher --no-document

# Expondo a porta para uso
EXPOSE 3000
EXPOSE 1025
EXPOSE 1080

# Inicialização
CMD ["sh", "-c", "rails db:reset db:create db:migrate && rails server -b 0.0.0.0 -d && /usr/local/bundle/bin/mailcatcher --ip=0.0.0.0 && bundle exec sidekiq"]
