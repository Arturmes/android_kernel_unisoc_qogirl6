# drm/tegra depends on host1x, so if both drivers are built-in care must be
# taken to initialize them in the correct order. Link order is the only way
# to ensure this currently.
obj-$(CONFIG_TEGRA_HOST1X)	+= host1x/
obj-y				+= drm/ vga/
obj-$(CONFIG_MALI_MIDGARD)	+= mali/
obj-$(CONFIG_IMX_IPUV3_CORE)	+= ipu-v3/
obj-$(CONFIG_TRACE_GPU_MEM)	+= trace/
