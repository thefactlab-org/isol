import { defineConfig } from "vocs";
import { version } from "./package.json";

export default defineConfig({
  title: "isol",
  banner: "isol is open-source software. Use at your own risk and responsibility. See [Privacy & Terms](/privacy-terms) for details.",
  editLink: {
    pattern:
      "https://github.com/thefactlab-org/isol/edit/main/docs/docs/pages/:path",
    text: "Suggest changes to this page",
  },
  sidebar: [
    {
      text: "Getting Started",
      link: "/getting-started",
    },
    {
      text: "Concept",
      link: "/concept",
    },
    {
      text: "Contracts",
      items: [
        {
          text: "Base",
          collapsed: false,
          items: [
            { text: "BasexERC20", link: "/contracts/base/BasexERC20" },
          ],
        },
        {
          text: "Kit",
          collapsed: false,
          items: [
            { text: "KitxERC20", link: "/contracts/kit/KitxERC20" },
            { text: "ERC20xTransferWithAuthorize", link: "/contracts/kit/ERC20xTransferWithAuthorize" },
            { text: "ERC20WrappedxWithAuthorize", link: "/contracts/kit/ERC20WrappedxWithAuthorize" },
          ],
        },
        {
          text: "Modular",
          collapsed: false,
          items: [
            { text: "ERC20xTransferWithAuthorize", link: "/contracts/modular/ERC20xTransferWithAuthorize" },
          ],
        },

      ],
    },
    { text: 'Privacy & Terms', link: '/privacy-terms' },
  ],

  socials: [
    {
      icon: "x",
      link: "https://x.com/thefactlab_org",
    },
    {
      icon: "github",
      link: "https://github.com/thefactlab-org/isol",
    }
  ],
  topNav: [
    { text: "Quick Start", link: "/getting-started#quick-start" },
    { text: "Concept", link: "/concept" },
    {
      text: version,
      items: [
        {
          text: "Changelog",
          link: "https://github.com/thefactlab-org/isol/blob/main/CHANGELOG.md",
        },
        {
          text: "Contributing",
          link: "https://github.com/thefactlab-org/isol/pulls",
        }
      ],
    },
  ],
});
