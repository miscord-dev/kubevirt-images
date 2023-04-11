#! /bin/zx

const path = require("path");

(async () => {
    const c = `ubuntu-kubeadm/22.04/config.json`;

    const dir = (await $`dirname ${c}`).stdout.trim();
    cd(dir);
    await $`packer build ${path.relative(dir, c)}`;

    await $`docker build -t ubuntu-kubeadm -f Dockerfile .`

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
