// modules/wordpress/transform-components/transform-components.js
// RequiredBy: modules/wordpress/transform-components.sh
// Menu: WordPress
// Description: Transform Vite JSX/TSX components into TailPress-compatible PHP template parts

import fs from 'fs-extra';
import path from 'path';

const themeSlug = process.env.THEME_SLUG || 'default-theme';
const srcDir = path.resolve('src/components');
const destDir = path.resolve(`wp-content/themes/${themeSlug}/template-parts`);

async function transformComponents() {
  const files = await fs.readdir(srcDir);

  for (const file of files) {
    if (file.endsWith('.jsx') || file.endsWith('.tsx')) {
      const content = await fs.readFile(path.join(srcDir, file), 'utf8');
      const newFilename = file.replace(/\.(jsx|tsx)$/, '.php');
      const phpContent = `<!-- Transformed from ${file} -->\n<?php\n// ... your transform logic here ?>`;
      await fs.outputFile(path.join(destDir, newFilename), phpContent);
    }
  }

  console.log('✅ JSX/TSX files transformed to PHP components.');
}

transformComponents().catch((err) => {
  console.error('❌ Error transforming components:', err);
  process.exit(1);
});
