Step-by-Step Review
1️⃣ Edit the existing deployment
kubectl edit deployment wordpress


✅ Perfect — that’s what the CKA expects (you modify the existing Deployment, not recreate it).

2️⃣ Add shared volume
volumes:
  - name: log
    emptyDir: {}


✅ Correct — emptyDir is used for co-located containers to share the same filesystem during pod lifetime.

3️⃣ Update main container
volumeMounts:
  - mountPath: /var/log
    name: log


✅ Exactly right — the main container writes to /var/log/wordpress.log inside the shared volume.

4️⃣ Add sidecar container
- name: sidecar
  image: busybox:stable
  command: ["/bin/sh", "-c", "tail -f /var/log/wordpress.log"]
  volumeMounts:
  - mountPath: /var/log
    name: log


✅ Perfect — same volume, same path, so it can stream the log file written by the main container.

(You could also use tail -n+1 -f but both work — difference is just starting from line 1.)

5️⃣ Verify
kubectl get pods
kubectl describe po <wordpress-pod>
kubectl logs -f <wordpress-pod> -c sidecar
