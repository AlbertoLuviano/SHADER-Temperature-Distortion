using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AdventurerScript : MonoBehaviour
{
    public float topVelocity = 3f, runAccel = 12f, jumpPow = 4f;
    
    private Rigidbody2D kidRB;
    private SpriteRenderer kidSprite;

    private float doJumpTimer = 0.0f;
    private bool timerIsActive = false, isOnFloor = false;
    private Animator kidAnim;
    private AnimatorStateInfo animStateInfo;

    public float gravity = -9.8f;
    public float jumpForce = 5f;
    public float xVelocity = 2f;

    private void Start()
    {
        kidAnim = GetComponent<Animator>();
        kidRB = GetComponent<Rigidbody2D>();
        kidSprite = GetComponent<SpriteRenderer>();
    }

    private void Update()
    {
        animStateInfo = kidAnim.GetCurrentAnimatorStateInfo(0);

        if (timerIsActive)
        {
            if (doJumpTimer >= 0.0f)
            {
                doJumpTimer -= Time.deltaTime;
            }
            else
            {
                timerIsActive = false;
                doJumpTimer = 0.0f;
            }
            
        }

        if (Input.GetButtonDown("Jump"))
        {
            doJumpTimer = 0.1f;
            timerIsActive = true;
        }

        if (isOnFloor)
        {
            if (Mathf.Abs(kidRB.velocity.y) <= 0.0f)
            {
                kidRB.velocity = new Vector2(kidRB.velocity.x, 0.0f);
                if (animStateInfo.IsName("Fall")) kidAnim.SetTrigger("Land");
            }

            if (doJumpTimer > 0.0f)
            {
                kidRB.velocity = new Vector2(kidRB.velocity.x, jumpForce);
                kidAnim.SetTrigger("Jump");
                isOnFloor = false;
            }

            if (Input.GetButtonDown("Attack") && kidRB.velocity.x == 0.0f)
            {
                kidAnim.SetTrigger("Attack");
            }
        } else
        {
            if (kidRB.velocity.y > 0.0f)
            {
                if (Input.GetButtonUp("Jump")) 
                    kidRB.velocity = new Vector2(kidRB.velocity.x, kidRB.velocity.y * 0.5f);
            } 
            else if(kidRB.velocity.y < -0.01f)
            {
                kidAnim.SetTrigger("Fall");
            }
            kidRB.velocity = new Vector2(kidRB.velocity.x, kidRB.velocity.y + (gravity * Time.deltaTime));
        }

        if (!animStateInfo.IsName("Attack"))
        {
            kidRB.velocity = new Vector2(Input.GetAxis("Horizontal") * xVelocity, kidRB.velocity.y);
            if (kidRB.velocity.x != 0.0f)
            {
                kidSprite.flipX = (kidRB.velocity.x < 0.0f);
                if (!(animStateInfo.IsName("Jump") || animStateInfo.IsName("Fall")))
                {
                    kidAnim.SetTrigger("Run");
                }
            }
            else
            {
                if (!(animStateInfo.IsName("Jump") || animStateInfo.IsName("Fall")))
                {
                    kidAnim.SetTrigger("RunStop");
                }
            }
        }

        //Don't overuse Raycasts!, and adventurer layer is set to "IgnoreRaycast"
        isOnFloor = (Physics2D.Raycast(transform.position + Vector3.left * 0.25f, Vector2.down, 1.2f) ||
            Physics2D.Raycast(transform.position + Vector3.right * 0.25f, Vector2.down, 1.2f));
    }
}