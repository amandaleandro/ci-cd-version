module.exports = {
  branches: ['main'],
  repositoryUrl: 'https://github.com/amandaleandro/ci-cd-version.git',
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/github',
    '@semantic-release/git'
  ]
};
