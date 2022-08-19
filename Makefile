
csi-attacher-v3.5.0.done: csi-attacher-v3.5.0.make
	make -f csi-attacher-v3.5.0.make all
	docker images | head > csi-attacher-v3.5.0.done

cloud-provider-openstack.v1.24.2.done: cloud-provider-openstack.v1.24.2.make
	make -f cloud-provider-openstack.v1.24.2.make all
	docker images | head > cloud-provider-openstack.v1.24.2.done

all: *.done
