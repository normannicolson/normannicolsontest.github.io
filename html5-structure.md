# Html5 Structure

Oct 2017

> How html 5 elements relate to each other.

```
<body>
  <main>
    <article>
      <aside>Related to the article</aside>
      <section>
        <aside>Related to the section</aside>
        <blockquote>
          <aside>Related to the blockquote not to the section</aside>
        </blockquote>
        <div>
          <aside>Related to the section not to the div</aside>
        </div>
      </section>
    </article>
    <aside>Related to the body not to the main</aside>
  </main>

  <aside>
    Related to the body
    <aside>Related to the parent aside</aside>
  </aside>

  <nav>
    <aside>Related to the nav</aside>
  </nav>

  <footer>
    <aside>Related to the body not to the footer</aside>
  </footer>
</body>
```