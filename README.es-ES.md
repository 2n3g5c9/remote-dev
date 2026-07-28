# `remote-dev` (en GCP)

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/2n3g5c9/remote-dev/master.svg)](https://results.pre-commit.ci/latest/github/2n3g5c9/remote-dev/master)
[![Packer](https://github.com/2n3g5c9/remote-dev/actions/workflows/packer.yml/badge.svg)](https://github.com/2n3g5c9/remote-dev/actions/workflows/packer.yml)
[![Terraform](https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml/badge.svg)](https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml)

Automatiza el aprovisionamiento de un servidor de desarrollo efímero en [Google Cloud Platform](https://cloud.google.com/).
Se construye una imagen inmutable con [Packer](https://packer.io/) y se despliega en una instancia de [Compute Engine](https://cloud.google.com/compute) `e2-micro` (en `us-east1-b` para entrar en el nivel gratuito) con [Terraform](https://www.terraform.io/), todo a través de [Cloud Build](https://cloud.google.com/cloud-build).
La instancia solo es accesible vía SSH y MOSH en tu red de [Tailscale](https://tailscale.com/).

## Diagrama

<p align="center">
    <img src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/diagram.png" alt="diagram" width="838px"/>
</p>

## Uso

### ✅ Prerrequisitos

#### 🔐 Genera tu par de claves SSH

Si aún no tienes un par de claves SSH, genera uno (preferiblemente con una frase de contraseña de alta entropía):

```bash
ssh-keygen -o -a 100 -t ed25519 -C remote-dev
```

#### 👷‍♂️ Configura Cloud Build

Ejecuta el script de configuración para establecer los permisos para llamar a las APIs de los servicios y configurar Packer/Terraform:

```bash
./run.sh -s
```

### ⚙️ Construye la imagen de la máquina

En el repositorio `remote-dev`, envía el trabajo de **Cloud Build** de Packer:

```bash
./run.sh -p
```

### 🚀 Despliega el servidor

En `remote-dev/terraform/env/prod/terraform.tfvars`, reemplaza el usuario SSH/clave pública y las direcciones IP de las máquinas de Tailscale con tus propios valores.

Genera una [clave efímera de Tailscale](https://login.tailscale.com/admin/settings/authkeys) y configúrala:

```bash
export TAILSCALE_KEY="tskey-xxx"
```

Luego, en el repositorio `remote-dev`, envía los trabajos de **Cloud Build** de Terraform:

```bash
./run.sh -t
```

Una vez desplegado, puedes establecer [ACLs de Tailscale](https://login.tailscale.com/admin/acls) explícitos como el siguiente para restringir el acceso a la red en tu malla:

```json
{
  "Hosts": {
    "remote-dev": "INSERT_IP_ADDRESS_HERE"
  },
  "ACLs": [
    { "Action": "accept", "Users": ["INSERT_USERNAME_HERE"], "Ports": ["remote-dev:22,60000-61000"] }
  ]
}
```

### 💥 Destruye el servidor

En el repositorio `remote-dev`, envía los trabajos de **Cloud Build** para Terraform Destroy:

```bash
./run.sh -d
```

## Acerca de

### 🧰 Tecnología/frameworks utilizados

- [Google Cloud Build](https://cloud.google.com/cloud-build): Un servicio para "Construir, probar y desplegar continuamente".
- [Packer](https://www.packer.io/): Una herramienta para "Construir Imágenes de Máquina Automatizadas".
- [Terraform](https://www.terraform.io/): Una herramienta para "Escribir, Planificar y Crear Infraestructura como Código".
- [Tailscale](https://tailscale.com/): Una VPN de malla WireGuard sin configuración.

### 📃 Licencia

Este proyecto está licenciado bajo la Licencia MIT; consulta el archivo [LICENSE](LICENSE) para más detalles.
