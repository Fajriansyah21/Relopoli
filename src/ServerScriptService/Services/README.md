# ServerScriptService / Services

Tempat service server yang mengelola kapabilitas lintas sistem, seperti State Manager, persistence adapters, mutation execution, dan koordinasi server.

Service yang mengubah state harus menjaga validasi terbaru, urutan mutation, dan batas commit tanpa yield sesuai keputusan arsitektur.
