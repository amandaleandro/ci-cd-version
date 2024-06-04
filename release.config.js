module.exports = {
  branches: ['main'],
  repositoryUrl: 'https://github.com/amandaleandro/ci-cd-version',
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
  ci: false,
  exec: true,
  npmGlobal: false,
  npmClient: 'npm',
  tarballDir: 'dist',
  publishCmd: 'npx semantic-release',
  verifyConditionsCmd: 'npx semantic-release',
};
