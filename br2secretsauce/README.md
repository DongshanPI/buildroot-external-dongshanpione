# br2secretsauce

Common Makefile targets I use for buildroot stuff.

Usually I want a system image that is built with a few
external br2 directories and a rescue image that can
be used to used to recover a broken system.

## Targets

### Main system image

`buildroot`
`buildroot-menuconfig`
`buildroot-savedefconfig`

### Rescue system image

`buildroot-rescue`
`buildroot-rescue-menuconfig`
`buildroot-rescue-savedefconfig`
