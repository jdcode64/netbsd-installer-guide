# Guía de Instalación NetBSD 11.0 (Triple-Boot: Windows 11 + Debian + NetBSD)

Manual y simulador interactivo adaptado para dispositivos móviles y escritorio. Permite seguir la instalación 100% offline preservando particiones existentes en discos NVMe/GPT.

---

## 📱 Acceso Online (Desde el Celular)
Puedes abrir el simulador y la guía directamente en tu teléfono a través de GitHub Pages:
**[Abrir Simulador y Guía Móvil](https://udiaz60.github.io/netbsd-installer-guide/)**

---

## ⚡ Reglas de Oro (Preservación de Datos)
1. **NO usar `Use entire disk`**: Esta opción borra Windows y Debian. Seleccionar siempre **`Edit GPT partitions`**.
2. **Identificación de Particiones**:
   - `Partición 1`: EFI System (200MB, FAT32) -> **NO TOCAR**
   - `Partición 3`: Windows 11 (C:) -> **NO TOCAR**
   - `Partición 5`: Datos (D:) -> **NO TOCAR**
   - `Partición 6`: Debian GNU/Linux -> **NO TOCAR**
   - `Partición 8`: Espacio libre -> Asignar tipo **`NetBSD FFS`** con punto de montaje **`/`**.
3. **Gestor de Arranque**: Seleccionar **`Do not change the bootcode`** para no alterar UEFI.

---

## 🐧 Configuración Triple-Boot en Debian (GRUB)
Al finalizar la instalación de NetBSD, reinicia en Debian y ejecuta en la terminal:

```bash
sudo nano /etc/grub.d/40_custom
```

Añade las siguientes líneas al final:

```text
menuentry "NetBSD 11.0 (amd64)" {
    insmod ufs2
    set root=(hd0,gpt8)
    knetbsd /netbsd --root=ld0a
}
```

Actualiza el menú de inicio:
```bash
sudo update-grub
```

---

## 📶 Conectividad de Red en NetBSD
- **Wi-Fi interna (Realtek RTL8852BE)**: Actualmente no soportada nativamente en NetBSD.
- **Solución inmediata (USB Tethering con Celular)**:
  1. Conecta tu teléfono Android por cable USB y activa *Conexión compartida USB*.
  2. En NetBSD ejecuta:
     ```sh
     ifconfig -a       # Aparecerá como urndis0
     dhcpcd urndis0    # IP y conexión a internet al instante
     ```

---

## 📦 Sets de Instalación Offline
Los sets oficiales se encuentran en `sets_11.0/` verificados con SHA512:
- `base.tar.xz`, `etc.tar.xz`, `rescue.tar.xz`
- `kern-GENERIC.tar.xz`, `kern-GENERIC_KASLR.tar.xz`, `modules.tar.xz`
- `gpufw.tar.xz` (Firmware para GPU AMD Radeon)
- `xbase.tar.xz`, `xserver.tar.xz`, `xfont.tar.xz`, `xetc.tar.xz`, `xcomp.tar.xz` (X11)
- `man.tar.xz`, `comp.tar.xz`, `text.tar.xz`
