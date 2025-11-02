# drivers_PZ_5
## 1. Подготовка среды
Команды установки зависимостей
```
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r) git
```
Эти пакеты необходимы для сборки модулей ядра и работы с Git.

## 2. Создание проекта
```
mkdir ~/mai_practice5
cd ~/mai_practice5
```
Созданы файлы:
- mai_practice5.c — код драйвера
- rawexample.c — приложение для отправки кадров
- Makefile — для сборки модуля и программы
## 3. Сборка проекта
```
make
```
Вывод:
```
make -C /lib/modules/6.8.0-79-generic/build M=/home/drivers/mai_practice5 modules
make[1]: Entering directory '/usr/src/linux-headers-6.8.0-79-generic'
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: x86_64-linux-gnu-gcc-13 (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
  You are using:           gcc-13 (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
  CC [M]  /home/drivers/mai_practice5/mai_practice5.o
  MODPOST /home/drivers/mai_practice5/Module.symvers
  CC [M]  /home/drivers/mai_practice5/mai_practice5.mod.o
  LD [M]  /home/drivers/mai_practice5/mai_practice5.ko
  BTF [M] /home/drivers/mai_practice5/mai_practice5.ko
Skipping BTF generation for /home/drivers/mai_practice5/mai_practice5.ko due to unavailability of vmlinux
make[1]: Leaving directory '/usr/src/linux-headers-6.8.0-79-generic'
gcc rawexample.c -o rawexample
```
Модуль ядра mai_practice5.ko успешно собран

## 4. Загрузка модуля
```
sudo insmod mai_practice5.ko
sudo dmesg | tail
```
Вывод:
```
[11303.840296] audit: type=1400 audit(1762120765.882:127): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/__init__.cpython-312.pyc.135721072856496" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11303.895524] audit: type=1400 audit(1762120765.936:128): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/log.cpython-312.pyc.135721077553536" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.000036] audit: type=1400 audit(1762120766.041:129): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/defaults.cpython-312.pyc.135721071745072" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.029931] audit: type=1400 audit(1762120766.071:130): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/secret_manager.cpython-312.pyc.135721071745072" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.100765] audit: type=1400 audit(1762120766.141:131): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/system.cpython-312.pyc.135721071747120" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.263125] audit: type=1400 audit(1762120766.303:132): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/__pycache__/exceptions.cpython-312.pyc.135721072193072" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.350785] audit: type=1400 audit(1762120766.382:133): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/messages/__pycache__/__init__.cpython-312.pyc.135721070968112" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11304.387933] audit: type=1400 audit(1762120766.429:134): apparmor="DENIED" operation="mknod" class="file" profile="ubuntu_pro_esm_cache" name="/usr/lib/python3/dist-packages/uaclient/messages/__pycache__/urls.cpython-312.pyc.135721070968112" pid=2162 comm="python3" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[11377.114057] mai_practice5: device initialized
[11377.121374] mai_practice5: module loaded
```
Модуль загружен, устройство зарегистрировано. 
Проверка появления интерфейса:
```
ip link show
```
Фрагмент вывода:
```
6: maidev0: <BROADCAST,MULTICAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
```
Устройство maidev0 зарегистрировано системой
## 5. Поднятие интерфейса и назначение IP
```
sudo ip addr add 192.168.1.10/24 dev maidev0
sudo ip link set maidev0 up
ip addr show maidev0
```
Вывод:
```
6: maidev0: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.10/24 scope global maidev0
       valid_lft forever preferred_lft forever
    inet6 fe80::200:ff:fe00:0/64 scope link
       valid_lft forever preferred_lft forever
```
Интерфейс активен и готов к передаче пакетов
### Передача тестового кадра
```
sudo ./rawexample
```
Вывод:
```
Success!
```
### Проверка логов ядра
```
sudo dmesg | tail
```
Результат:
```
[12613.701630] mai_practice5: module loaded
[12643.031589] mai_practice5: device opened
[12643.036557] mai_practice5: hard_start_xmit called
[12643.036565] src: 00:00:00:00:00:00 -> dst: 33:33:00:00:00:02, len: 70
[12647.734896] mai_practice5: hard_start_xmit called
[12647.734912] src: 00:00:00:00:00:00 -> dst: 33:33:00:00:00:02, len: 70
[12656.950653] mai_practice5: hard_start_xmit called
[12656.950665] src: 00:00:00:00:00:00 -> dst: 33:33:00:00:00:02, len: 70
[12664.320873] mai_practice5: hard_start_xmit called
[12664.320882] src: 00:00:00:00:00:00 -> dst: 00:12:34:56:78:90, len: 23
```
Драйвер получил и обработал кадр
Функция hard_start_xmit успешно отработала, MAC-адреса и длина пакета отображены в логе
## 6. Выгрузка модуля
```
sudo rmmod mai_practice5
sudo dmesg | tail
```

🧾 Вывод:

mai_practice5: cleaning up module
