# Coffee and Coding

This publically accessible repository will hold all materials for Coffee and Coding sessions held by the NHS Business Services Authority.

The goal of these sessions is to provide a relaxed environment to share new skills and encourage people to pick up the keyboard and learn to code. The sessions will last ~ 45 minutes and should include some kind of hands on code for others to try out your material.

We will utilise [Binder](https://mybinder.org/v2/gh/sfdsa/HEAD) as a free online interactive environment to execute code in online. If you are playing along, please launch a JupyterLab instance [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gl/nhsbsa%2Finsight%2Fshared%2Fcoffee-and-coding/master?urlpath=lab).

Our first session is organised for 19th May and we are actively looking for volunteers to plan and host future sessions.

When adding new content please:

- Use branching (create a branch and submit a merge request for approval when you are finished)
- Follow the naming convention for your session's directory (`YYYY-MM-DD Session Name`)
- Include a `README.md` for your session to introduce it (+ any slides that you use)
- Include code to play along as `.ipynb` files (to facilitate JupyterLab better than `.R` or `.py`)
- Update `environment.yml` with any new dependencies
- Build the docker image using Binder and check everything works 

Note: The easiest way to create new content is to use [conda](https://conda.io/projects/conda/en/latest/index.html) to create an environment using the `environment.yml` and then launch JupyterLab. 