FROM rocker/rstudio:4.2.2

LABEL org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.base.name="rocker/rstudio:4.2.2" \
      org.opencontainers.image.title="ubdems/tests-osmextract.anchor" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems/cs-labs/user-agilardi/tests-osmextract" \
      org.opencontainers.image.authors="Gilardi/Andrea <andrea.gilardi@unimib.it>" \
      org.opencontainers.image.description="Run tests for osmextract on VM" \
      org.opencontainers.image.licenses="TODO" \
      it.unimib.datalab.type="project.anchor" \
      it.unimib.datalab.name="tests-osmextract" \
      it.unimib.datalab.group="ub-dems/cs-labs/user-agilardi" \
      it.unimib.datalab.path="ub-dems/cs-labs/user-agilardi/tests-osmextract" \
      it.unimib.datalab.schema="dve:1.0" \
      it.unimib.datalab.lang="R" \
      it.unimib.datalab.from="2023-02-16" \
      it.unimib.datalab.until="2224-02-16" \
      it.unimib.datalab.owner="ag21052" \
      it.unimib.datalab.cdc="es-670" \
      it.unimib.datalab.tags="none"