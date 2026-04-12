# Setup Inicial - Oracle Labs AI

Esta carpeta contiene las guías para desplegar la solución base en OCI.

## Formas de despliegue

1. **Despliegue automático (recomendado)**
Descripción: usa un botón que abre OCI Resource Manager y carga directamente el stack `.zip`.

- Guía: [1-README-SETUP-AUTOMATICO.md](./1-README-SETUP-AUTOMATICO.md)
- Botón directo:
[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https%3A%2F%2Fgithub.com%2Fvalentinafeve%2Foracle-labs-ai%2Fraw%2Frefs%2Fheads%2Fmain%2Futils%2Foci-foundation-stack-rm.zip)

2. **Despliegue manual**
Descripción: crea el stack manualmente en Resource Manager cargando el archivo `.zip` y configurando variables paso a paso.

- Guía: [2-README-setup-Manual.md](./2-README-setup-Manual.md)

## Stack package

- ZIP del stack: `https://github.com/valentinafeve/oracle-labs-ai/raw/refs/heads/main/utils/oci-foundation-stack-rm.zip`
