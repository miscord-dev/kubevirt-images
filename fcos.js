#! /bin/zx

(async () => {
    await $`rm -r fcos || true`
    await $`mkdir -p fcos`
    cd(`fcos`)

    const pwd = (await $`pwd`).stdout

    await $`docker run --platform=linux/amd64 --security-opt label=disable --pull=always --rm -v ${pwd}:/data -w /data quay.io/coreos/coreos-installer:release download -f iso`
    
    await $`ls`

    await $`bash -c "mv *.iso image.img"`

    await $`docker build -t fcos -f ../Dockerfile .`

    await Promise.all(
        process.env.TAGS.split('\n').filter(x => x.length)
            .map(async (tag) => {
                await $`docker tag fcos ${tag}`
                await $`docker push ${tag}`
            })
        )
})().catch(err => {
    throw err;
})
