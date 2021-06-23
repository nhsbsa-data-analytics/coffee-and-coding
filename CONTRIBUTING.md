Create a branch and submit a merge request for approval:

- Follow the naming convention for your session's directory (`YYYY-MM-DD Session Name`)
- Include a `README.md` for your session to introduce it + any slides that you use as `.pdf` (renders in GitLab unlike `.pptx`)
- Include code to play along as `.ipynb` files (to facilitate JupyterLab better than `.R` or `.py`) and [clear all of the cell outputs](https://stackoverflow.com/questions/39924826/keyboard-shortcut-to-clear-cell-output-in-jupyter-notebook)
- Update `environment.yml` with any new dependencies

At this stage your branch will be merged and then you can:

- Build the docker image using Binder and check everything works

Finally, after your session:

- Update the `.ipynb` files to include the cell outputs

Note: The easiest way to create new content is to use [conda](https://conda.io/projects/conda/en/latest/index.html) to create an environment using the `environment.yml` and then launch JupyterLab. 
