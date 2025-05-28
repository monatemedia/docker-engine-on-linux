#!/bin/bash
# modules/wordpress/vite-to-tailpress.sh
# Menu: WordPress
# Description: Automate converting a Vite React template into a TailPress-based WordPress theme

convert_vite_to_tailpress() {
  echo "🚀 Starting conversion from Vite React to TailPress WordPress theme..."

  # Define source and destination paths
  TEMPLATE_DIR="$HOME/wordpress/template"
  THEME_DIR="$HOME/wordpress/wp-content/themes/super-test-site"

  # Copy styles
  echo "🎨 Merging CSS..."
  cat "$TEMPLATE_DIR/src/index.css" >> "$THEME_DIR/resources/css/app.css"

  # Copy React components as raw HTML placeholders to template-parts
  echo "📦 Converting components..."
  COMPONENTS_DIR="$TEMPLATE_DIR/src/components"
  DEST_PARTS_DIR="$THEME_DIR/template-parts"

  mkdir -p "$DEST_PARTS_DIR"
  for file in "$COMPONENTS_DIR"/*.tsx; do
    name=$(basename "$file" .tsx | tr '[:upper:]' '[:lower:]')
    dest="$DEST_PARTS_DIR/${name}.php"
    echo "<!-- Placeholder converted from $file -->" > "$dest"
    echo "<?php /* TODO: Convert content manually */ ?>" >> "$dest"
    echo "Created: $dest"
  done

  # Copy index.html layout shell into index.php (basic example)
  echo "🧱 Setting up index.php layout..."
  cp "$THEME_DIR/index.php" "$THEME_DIR/index.php.bak"
  echo "<?php get_header(); ?>" > "$THEME_DIR/index.php"
  echo "<main class='container mx-auto'>" >> "$THEME_DIR/index.php"
  echo "<?php get_template_part('template-parts/hero'); ?>" >> "$THEME_DIR/index.php"
  echo "<?php get_template_part('template-parts/about'); ?>" >> "$THEME_DIR/index.php"
  echo "<?php get_template_part('template-parts/services'); ?>" >> "$THEME_DIR/index.php"
  echo "<?php get_template_part('template-parts/contact'); ?>" >> "$THEME_DIR/index.php"
  echo "</main>" >> "$THEME_DIR/index.php"
  echo "<?php get_footer(); ?>" >> "$THEME_DIR/index.php"

  echo "✅ Conversion complete!"
}

# Run the function
convert_vite_to_tailpress
