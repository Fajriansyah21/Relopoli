# ReplicatedStorage / Remotes

Tempat deklarasi RemoteEvent/RemoteFunction yang menjadi kontrak komunikasi client-server.

Setiap request harus mengikuti kontrak server-authoritative: identitas request, validasi player dan context, deduplikasi, rate limit, serta penolakan tanpa side effect untuk request invalid. Detail final mengikuti Architecture Decision Log.
