<h3 id="genrichpip">Genrich pipeline</h3>
<h4 id="genrich">Genrich</h4>
  <ul>
        <li>file name: <code>template_Genrich.sh</code></li>
        <li>options:</li>
        <ul>
          <li><code>-r       #Remove PCR duplicates</code></li>
          <li><code>-q 0.05  #Maximum q-value (FDR-adjusted p-value; def. 1)</code></li>
          <li><code>-m 5     #Minimum MAPQ to keep an alignment (def. 0)</code></li>
        </ul>  
        <li>commande: <code>Genrich -r  -t $f1  -o $out -b $bed -R $dup -q 0.05 -m 5</code></li>
 </ul> 
