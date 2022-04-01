PREFIX = dongshanpione
DEFCONFIG = ../br2dongshanpione/configs/dongshanpione_defconfig
DEFCONFIG_RESCUE = ../br2dongshanpione/configs/dongshanpione_rescue_defconfig
EXTERNALS +=../br2autosshkey ../br2chenxing ../br2dongshanpione
TOOLCHAIN = arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz

all: buildroot-dl buildroot buildroot-rescue copy_outputs upload

bootstrap.stamp:
	touch bootstrap.stamp

./br2secretsauce/common.mk: bootstrap.stamp
./br2secretsauce/rescue.mk: bootstrap.stamp
./br2secretsauce/ubi.mk: bootstrap.stamp

bootstrap: bootstrap.stamp

include ./br2secretsauce/common.mk
include ./br2secretsauce/rescue.mk
include ./br2secretsauce/ubi.mk

.PHONY: ubi.img

ubi.img:
	- rm ubinize.cfg.tmp
	dd if=/dev/zero bs=1024 count=256 | tr '\000' '1' > env.img
	$(call ubi-add-vol,0,uboot,1MiB,static,$(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call ubi-add-vol,1,env,256KiB,static,env.img)
	$(call ubi-add-vol,2,rescue,16MiB,static,$(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)
	$(call ubi-add-vol,3,kernel,16MiB,static,$(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call ubi-add-vol,4,rootfs,64MiB,dynamic,$(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	/usr/sbin/ubinize -o $@ -p 128KiB -m 2048 -s 2048 ubinize.cfg.tmp

copy_outputs: ubi.img
	cp br2dongshanpione/board/100ask/dongshanpione/GCIS.bin  $(OUTPUTS)/GCIS.bin
	cp br2dongshanpione/board/100ask/dongshanpione/IPL.bin $(OUTPUTS)/IPL.bin
	cp buildroot/output/images/ipl $(OUTPUTS)/dongshanpione-ipl
	cp buildroot/output/images/u-boot.img $(OUTPUTS)/dongshanpione-u-boot.img
	cp buildroot/output/images/kernel.fit $(OUTPUTS)/dongshanpione-kernel.fit
	cp buildroot/output/images/rootfs.squashfs $(OUTPUTS)/dongshanpione-rootfs.squashfs
	cp buildroot_rescue/output/images/kernel-rescue.fit $(OUTPUTS)/dongshanpione-kernel-rescue.fit
	$(call copy_to_outputs, ubi.img)

upload:
	$(call upload_to_tftp_with_scp,$(BUILDROOT_PATH)/output/images/ipl)
	$(call upload_to_tftp_with_scp,$(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call upload_to_tftp_with_scp,$(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call upload_to_tftp_with_scp,$(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	$(call upload_to_tftp_with_scp,$(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)
