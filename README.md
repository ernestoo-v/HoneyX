# 🐝 HoneyX

<p align="center">
  <img src="img/HoneyX.png" alt="Logo HoneyX" width="350">
</p>


**HoneyX** es un sistema honeypot distribuido. Su objetivo es simular servicios vulnerables para atraer posibles atacantes y registrar sus actividades. El sistema está dividido en dos componentes principales:

- **Honeypot**: Simula servicios vulnerables y recopila datos de posibles intrusiones.
- **Monitorización**: Analiza y visualiza los datos recopilados mediante herramientas como Grafana y Prometheus.

---

## 📁 Estructura del Proyecto

```plaintext
.
├── scripts_honeypot/
│   ├── 01_setup.sh
│   ├── 02_gen_compose.sh
│   ├── 03_prometheus.sh
│   ├── 04_ftp.sh
│   ├── 05_apache.sh
│   ├── 051_create_apache.sh
│   ├── 06_mysql.sh
│   ├── 061_sql_init.sh
|   └── 07_promtail.sh
├── scripts_monitor/
│   ├── 01_setup.sh
│   ├── 02_gen_compose
│   ├── 03_loki.sh
│   ├── 04_grafana.sh
|   ├── antiguo_grafana.json
|   └── apache_grafana.json
├── web/
├── 00_run_all_honeypot.sh
├── 00_run_all_monitor.sh
└── README.md
```

---

## ⚙️ Servicios Simulados

### 🔐 Honeypot

- **Apache** – Servidor web vulnerable.
- **ProFTPD** – Servidor FTP.
- **FakeSSH** – Simulación de servicio SSH para detectar escaneos o intentos de acceso.
- **MySQL** – Base de datos simulada vulnerable.
- **Promtail** – Recolector y etiquetador de logs que los envía a Loki.
- **Prometheus** – Sistema de monitorización.
- **Node Exporter** – Exportador de métricas del sistema para Prometheus.

### 📊 Monitorización

- **Grafana** – Panel de visualización de logs y métricas.
- **Loki** – Sistema de gestión centralizada de logs.

---

## 🚀 Cómo ponerlo en marcha

### 🔽 1. Clonar el repositorio

```bash
git clone https://github.com/ernestoo-v/HoneyX
cd HoneyX
```

### 🐝 2. Desplegar la máquina Honeypot

```bash
chmod +x 00_run_all_honeypot.sh
sudo ./00_run_all_honeypot.sh
```

Una vez ejecutado el propio script se te pedirá que introduzcas la IP de la Máquina de Monitorización para el correcto funcionamiento de Loki.

```bash
cd honeypot
docker-compose up -d --build
```

### 📈 3. Desplegar la máquina de Monitorización

```bash
chmod +x 00_run_all_monitor.sh
sudo ./00_run_all_monitor.sh
```

Una vez ejecutado el propio script se te pedirá que introduzcas la IP de la Máquina Honeypot para el correcto funcionamiento de Prometheus.

```bash
cd honeypot
docker-compose up -d --build
```

## 🌐 Cómo acceder a Grafana

Una vez desplegado el entorno de monitorización, accede a Grafana desde tu navegador web:

```cpp
http://<IP_DE_LA_MÁQUINA_MONITORIZACIÓN>:3000
```

Usuario: admin
Contraseña: admin

🔐 Se recomienda cambiar la contraseña por defecto tras el primer inicio de sesión.

## Logs y Métricas

Los servicios simulados generan logs que se almacenan en volúmenes locales dentro de la máquina honeypot.

Promtail los recolecta y envía a Loki, donde se almacenan y están disponibles para consulta.

Estarán automáticamente creados en el apartado de dashboards los dashboards necesarios para la correcta visualización de todos los servicios.

Las métricas del sistema (uso de CPU, memoria, etc.) se recogen con Node Exporter y se visualizan en Grafana mediante Prometheus.

## ✅ Requisitos del Sistema

Docker → Instalar Docker

Docker Compose → Instalar Docker Compose

## 📬 Contacto

Autores: GutiFer4 | ernestoo-v

Repositorio original: HoneyX
