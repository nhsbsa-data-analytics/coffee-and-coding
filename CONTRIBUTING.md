Create a branch and submit a merge request for approval by at least one of the previous hosts:

- Follow the naming convention for your session's directory (`YYYY-MM-DD Session Name`)
- Include a `README.md` for your session to introduce it + any slides that you use as `.pdf` (renders in GitHub unlike `.pptx`)
- Include code to play along as either:
    + `.ipynb` notebooks (to facilitate JupyterLab better than `.R` or `.py` ensuring you [clear all of the cell outputs](https://stackoverflow.com/questions/39924826/keyboard-shortcut-to-clear-cell-output-in-jupyter-notebook) before your session)
    + `.R` files if you are demoing RStudio / R Shiny
- Update Python (`environment.yml`) and R (`install.R`) with any new dependencies

At this stage your branch will be merged and then you can:

- Build the docker image using Binder and check everything works

Finally, after your session:

- Update the `.ipynb` files to include the cell outputs if you used them

Note: If you are using `.ipynb` notebooks then the easiest way to create new content is by using [conda](https://conda.io/projects/conda/en/latest/index.html) to create an environment using `environment.yml` and then launch JupyterLab.
