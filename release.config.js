module.exports = {
  branches: ['main'],
  repositoryUrl: 'https://github.com/your-username/your-repo.git',
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/github',
    [
      '@semantic-release/git',
      {
        assets: ['package.json', 'CHANGELOG.md'],
        message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
      },
    ],
  ],
  // Adicione a configuração para usar Node.js v18
  ci: false, // Desativa a execução em um ambiente de CI
  exec: true, // Ativa a execução de comandos do shell
  npmGlobal: false, // Desativa o uso de pacotes globais npm
  npmClient: 'npm', // Define o cliente npm a ser usado (pode ser "npm" ou "yarn")
  tarballDir: 'dist', // Define o diretório onde os arquivos tarball devem ser armazenados
  publishCmd: 'npx semantic-release', // Define o comando de publicação
  verifyConditionsCmd: 'npx semantic-release', // Define o comando para verificar as condições de lançamento
};
