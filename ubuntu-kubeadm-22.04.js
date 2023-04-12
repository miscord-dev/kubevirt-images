#! /bin/zx

const path = require("path");

(async () => {
    const dir = `ubuntu-kubeadm/22.04`;

    cd(dir);
    await $`packer build -var k8s-version=${process.env.K8S_VERSION} .`;

    await $`docker build -t ubuntu-kubeadm -f Dockerfile .`

    if (!!process.env.IS_PULL_REQUEST) {
        return;
    }

    await Promise.all(
        process.env.TAGS.split('\n').filter(x => x.length)
            .map(async (tag) => {
                await $`docker tag ubuntu-kubeadm ${tag}`
                await $`docker push ${tag}`
            })
        )
})().catch(err => {
    throw err;
})
