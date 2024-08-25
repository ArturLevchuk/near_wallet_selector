import { defineConfig } from "vite";
import babel from "vite-plugin-babel";
import { nodePolyfills } from "vite-plugin-node-polyfills";
import topLevelAwait from "vite-plugin-top-level-await";
import cssInjectedByJsPlugin from 'vite-plugin-css-injected-by-js'

export default defineConfig({
  base: "./",
  plugins: [
    babel(),
    nodePolyfills(),
    topLevelAwait(),
    cssInjectedByJsPlugin()
  ],
  build: {
    rollupOptions: {
      output: {
        entryFileNames: "bundle.js",
        chunkFileNames: "bundle.js",
        assetFileNames: "[name][extname]",
      }
    },
  },
  server: {
    open: "/index.html",
    port: 3000,
  }
});
