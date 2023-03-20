#! /bin/zx

(async () => {
    await $`docker build -t fcos -f ../fcos.Dockerfile .`

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
