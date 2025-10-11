# Introduction

This lab explores dynamic app config using flagd + file mounted from hostpath.
The solution leverages OS-level inotify event, watched by flagd, which enables
application picks up config changes instantly.

Key advatanges of this approach include:

- instant change propagation thru running applications
- no shared storage required, saving costs
- simpler architecture, local development friendly
