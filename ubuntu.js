#! /bin/zx

(async () => {
    await $`docker build -t ubuntu -f ubuntu.Dockerfile .`

    await Promise.all(
        process.env.TAGS.split('\n').filter(x => x.length)
            .map(async (tag) => {
                await $`docker tag ubuntu ${tag}`
                await $`docker push ${tag}`
            })
        )
})().catch(err => {
    throw err;
})
